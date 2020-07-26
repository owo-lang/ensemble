(**************************************************************)
(* ENCRYPT.ML *)
(* Author: Mark Hayden, 4/97 *)
(* Change by Ohad Rodeh 10/2001 *)
(**************************************************************)
open Trans
open Buf
open Layer
open View
open Event
open Util
open Shared 
(**************************************************************)
let name = Trace.filel "ENCRYPT"
let log = Trace.log name
let failwith s = Trace.make_failwith name s
(**************************************************************)

type header = NoHdr | Encrypted of len

type state ={
  shared        : Cipher.t ;
  x_cast	: Cipher.context ;
  x_send        : Cipher.context array ;
  r_cast	: Cipher.context array ; 
  r_send	: Cipher.context array 
}

let dump = Layer.layer_dump name (fun (ls,vs) (s : state) -> [|
|])

let init _ (ls,vs) = 
  let shared = Cipher.lookup "OpenSSL/RC4" in
  let chan e = Cipher.init shared (Security.get_cipher vs.key) e in

  { 
    shared = shared; 
    x_cast = chan true ;
    r_cast = Array.init ls.nmembers (fun _ -> chan false ) ;
    x_send = Array.init ls.nmembers (fun _ -> chan true ) ;
    r_send = Array.init ls.nmembers (fun _ -> chan false ) 
  }

let hdlrs s ((ls,vs) as vf) {up_out=up;upnm_out=upnm;dn_out=dn;dnlm_out=dnlm;dnnm_out=dnnm} =
  let log = Trace.log2 name ls.name in

  (* Encrypt in-place.
   *)
  let core iovl ctx = 
    let iov = Iovecl.flatten_w_copy iovl in
    Iovecl.free iovl;
    Cipher.encrypt_inplace s.shared ctx iov;
    Iovecl.of_iovec iov
  in
  
  (* Encrypt the iovec.  Note that most encryption algorithms requires that the
   * payload size be a multiple of 8.
   *)
  let encrypt ev chan =
    let iov = getIov ev in
    let len = Iovecl.len iov in
    if len =|| len0 then ev,len else (
      let fill = len8 -|| (len_of_int ((int_of_len len) mod 8)) in
      let fill = if fill =|| len8 then len0 else fill in
      let iov =
	if fill =|| len0 then
          iov
	else (
	  (* Add some random filler data to the end.
	   *)
	  log (fun () -> sprintf "filler=%d" (int_of_len fill));
          Iovecl.append iov (Iovecl.of_iovec (Iovec.alloc fill))
	)
      in
      let iov = core iov chan in
      let ev = set name ev [Iov iov] in
      ev,len
    )
  in
  
  (* Decrypt the iovector and chop of excess iovec data.
   *)
  let decrypt ev chan actual =
    let iov = getIov ev in
    let len = Iovecl.len iov in
    if len =||len0 then ev else (
      assert ((int_of_len len) mod 8 = 0);
      let iov = core iov chan in
      let iov_new = Iovecl.sub iov len0 actual in
      Iovecl.free iov;
      let ev = set name ev [Iov iov_new] in
      ev
    )
  in

  
  let up_hdlr ev abv hdr = match getType ev, hdr with
  | ECast, Encrypted actual -> 
      log (fun () -> sprintf "[decrypting len=%d" (int_of_len actual));
      let src = getPeer ev in
      log (fun () -> "]");
      let ev = decrypt ev s.r_cast.(src) actual in
      up ev abv
	
  | ESend, Encrypted actual -> 
      log (fun () -> sprintf "[decrypting len=%d" (int_of_len actual));
      let src = getPeer ev in
      let ev = decrypt ev s.r_send.(src) actual in
      log (fun () -> "]");
      up ev abv
	
  | _, NoHdr -> up ev abv
  | _, _     -> failwith bad_up_event

  and uplm_hdlr ev () = failwith "got uplm event"
  and upnm_hdlr = upnm
  
  and dn_hdlr ev abv = match getType ev with
  | ECast when getApplMsg ev -> 
      log (fun () -> "[encrypting");
      let ev,len = encrypt ev s.x_cast in
      log (fun () -> sprintf "actual=%d]" (int_of_len len));
      dn ev abv (Encrypted len)

  | ESend when getApplMsg ev -> 
      log (fun () -> "[encrypting");
      let dst = getPeer ev in
      let ev,len = encrypt ev s.x_send.(dst) in
      log (fun () -> sprintf "actual=%d]" (int_of_len len));
      dn ev abv (Encrypted len)

  | _ -> dn ev abv NoHdr

  and dnnm_hdlr = dnnm
in {up_in=up_hdlr;uplm_in=uplm_hdlr;upnm_in=upnm_hdlr;dn_in=dn_hdlr;dnnm_in=dnnm_hdlr}

let l args vs = Layer.hdr init hdlrs None (FullNoHdr NoHdr) args vs

let _ = Layer.install name l
    
(**************************************************************)
