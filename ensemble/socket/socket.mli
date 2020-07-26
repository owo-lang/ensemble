(**************************************************************)
(*
 *  Ensemble, (Version 1.00)
 *  Copyright 2000 Cornell University
 *  All rights reserved.
 *
 *  See ensemble/doc/license.txt for further information.
 *)
(**************************************************************)
(**************************************************************)
(* SOCKET.MLI *)
(* Authors: Robbert vanRenesse and Mark Hayden, 4/95 *)
(**************************************************************)

type socket

type buf = string
type ofs = int
type len = int

type 'a refcnt = { mutable count : int ; obj : 'a } 
type 'a iovec = { rbuf : 'a ; ofs : ofs ; len : len }

type timeval = {
  mutable sec10 : int ;
  mutable usec : int
} 

(**************************************************************)

val set_error_log : ((unit -> string) -> unit) -> unit

(**************************************************************)

(* Open a file descriptor for reading from stdin.  This is
 * for compatibility with Windows NT.  See
 * ensemble/socket/stdin.c for an explanation.  
 *)
val stdin : unit -> socket

(* For reading from stdin.
 *)
val read : socket -> buf -> ofs -> len -> len

(**************************************************************)

type sock_info = (socket array) * (bool array)
type select_info
val select_info : sock_info -> sock_info -> sock_info -> select_info

val select : select_info -> timeval -> int
val poll : select_info -> int

(**************************************************************)

(* Allocate a static string (with stat_alloc).
 *)
val static_string : len -> string

(* Release such a string (with stat_free).
 *)
val static_string_free : string -> unit

(* Check if portions of two strings are equal.
 *)
val substring_eq : string -> ofs -> string -> ofs -> len -> bool

(**************************************************************)

(* Optimized transmission functions.  No exceptions are
 * raised.  Scatter-gather used if possible.  No interrupts
 * are serviced during call.  No bounds checks are made.
 *)

type sendto_info
val sendto_info : socket -> Unix.msg_flag list -> Unix.sockaddr array -> sendto_info
val sendto : sendto_info -> buf -> ofs -> len -> unit

(**************************************************************)

(* Same as above except that exceptions are raised.
 *)
type send_info
val send_info : socket -> Unix.msg_flag list -> send_info
val sendp : send_info -> buf -> ofs -> len -> len

(**************************************************************)

val sendv : send_info -> string refcnt iovec array -> int
val sendtov : sendto_info -> string refcnt iovec array -> unit
val sendtosv : sendto_info -> string -> string refcnt iovec array -> unit
val sendtovs : sendto_info -> string refcnt iovec array -> string -> unit

(**************************************************************)

(*** Multicast support. *)

(* Return whether this host supports IP multicast. 
 *)
val has_ip_multicast : unit -> bool 

(* Setup a socket for multicast operation. 
 *)
val setsock_multicast : socket -> bool -> unit 

(* Join an IP multicast group. 
 *)
val setsock_join : socket -> Unix.inet_addr -> unit 

(* Leave an IP multicast group. 
 *)
val setsock_leave : socket -> Unix.inet_addr -> unit 

(**************************************************************)

(* Set size of sending buffers.
 *)
val setsock_sendbuf : socket -> int -> unit

(* Set size of receiving buffers.
 *)
val setsock_recvbuf : socket -> int -> unit

(* Set socket to be blocking/nonblocking.
 *)
val setsock_nonblock : socket -> bool -> unit

(* Set socket ICMP error reporting.  See sockopt.c.
 *)
val setsock_bsdcompat : socket -> bool -> unit

(**************************************************************)

(* MD5 support.
 *)
type md5_ctx
val md5_init : unit -> md5_ctx
val md5_update : md5_ctx -> buf -> ofs -> len -> unit
val md5_final : md5_ctx -> Digest.t

(**************************************************************)

(* HACK!  It's useful to be able to print these out as ints.
 *)
val int_of_file_descr : Unix.file_descr -> int
val int_of_socket : socket -> int

(**************************************************************)
(* PUSH_INT/POP_INT: read and write 4-byte integers to
 * strings in network byte order.
 *)
(*
val push_nint : buf -> ofs -> int -> unit 
val pop_nint : buf -> ofs -> int

(* INT_OF_SUBSTRING: read a 4-byte integer in host
 * byte order.
 *)
val int_of_substring : buf -> ofs -> int
*)
(**************************************************************)

(* Same as Unix.gettimeofday.  Except that
 * the caller passes in a timeval object that
 * the time is returned in.
 *)
val gettimeofday : timeval -> unit

(**************************************************************)

type process_handle

(* Create a socket that can be used in spawn_process().  It
 * is used to receive termination events on.  
 *)
val process_socket : unit -> socket

(* Usage: spawn_process "name-of-executable" arguments
 * socket.  E.g.: spawn_process "echo.exe" "echo hello
 * world" (Some skt).  Returns a handle on the process, and
 * eventually sends a termination event to the given socket.
 *)
val spawn_process : string -> string array -> socket option -> process_handle option

(* Returns the process handle and the termination status of
 * the next process (that was started using spawn_process on
 * the given socket) to terminate.  Unless the
 * process_status is WSTOPPED, the process handle is no
 * longer valid after this.  
 *)
val wait_process : socket -> (process_handle * Unix.process_status)

(* Terminates the given process immediately.
 *)
val terminate_process : process_handle -> unit

(**************************************************************)

val recv : socket -> buf -> ofs -> len -> len
val send : socket -> buf -> ofs -> len -> len

(**************************************************************)

type recv_info
val recv_info : socket -> recv_info

(* Receive on a datagram socket.  Some errors cause a 0 to
 * be returned instead of generating an exception.  Also,
 * the size & offset values should be 4-byte aligned and the
 * return value is guaranteed to be aligned as well
 * (non-aligned packets will be dropped!).  
 *)
val udp_recv : recv_info -> buf -> ofs -> len -> len

(* Similar to above but hacked a bit to deal with the 14 byte
 * ethernet header.
 *)
val eth_recv : recv_info -> buf -> ofs -> len -> len

(**************************************************************)

val heap : unit -> Obj.t array
val addr_of_obj : Obj.t -> string
val minor_words : unit -> int
val frames : unit -> int array array

(**************************************************************)
val socket_of_fd : Unix.file_descr -> socket
val fd_of_socket : socket -> Unix.file_descr
(**************************************************************)

(* Ethernet addresses.
 *)
type eth

type eth_sendto_info

(* Is ethernet supported?  Currently, only works on Linux.
 *)
val eth_supported : unit -> bool

val eth_init : string -> eth * socket

val eth_sendto_info :
    socket -> string(*interface*) -> int(*flags*) -> eth(*src*) -> eth array(*dests*) -> eth_sendto_info

val eth_sendtovs : eth_sendto_info -> string refcnt iovec array -> string -> unit

(* Convert back and forth between ethernet addresses and
 * binary strings.
 *)
val eth_to_bin_string : eth -> string
val eth_of_bin_string : string -> eth

(**************************************************************)