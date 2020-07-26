/**************************************************************/
/*
 *  Ensemble, (Version 1.00)
 *  Copyright 2000 Cornell University
 *  All rights reserved.
 *
 *  See ensemble/doc/license.txt for further information.
 */
/**************************************************************/
/**************************************************************/
/* SENDRECV.C */
/* Author: Mark Hayden, 5/96 */
/**************************************************************/
/* Based on otherlib/unix/sendrecv.c in Objective Caml */
/**************************************************************/
/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1996 Institut National de Recherche en Informatique et   */
/*  Automatique.  Distributed only by permission.                      */
/*								       */
/***********************************************************************/

#include "skt.h"

void serror(cmdname, cmdarg)
     const char * cmdname;
     value cmdarg;
{
  /* unix_error is from unixsupport.c */
  extern void unix_error(int errcode, const char * cmdname, value arg);
  unix_error(h_errno, cmdname, cmdarg);
}


#if defined(HAS_SOCKETS)

value skt_recv(sock, buff, ofs, len) /* ML */
     value sock, buff, ofs, len;
{
  int ret;
  SKTTRACE;
  ret = recv(Socket_val(sock), &Byte(buff, Long_val(ofs)), Int_val(len),0) ;
  if (ret == -1) serror("recv", Nothing);
  return Val_int(ret);
}

value skt_send(sock, buff, ofs, len) /* ML */
     value sock, buff, ofs, len;
{
  int ret;
  SKTTRACE;
  ret = send(Socket_val(sock), &Byte(buff, Long_val(ofs)), Int_val(len),0) ;
  if (ret == -1) serror("send", Nothing);
  return Val_int(ret);
}

void skt_recv_error(void) {
  switch (h_errno) {
#ifdef EPIPE
  case EPIPE:
#endif
#ifdef EINTR
  case EINTR:
#endif
#ifdef EAGAIN
  case EAGAIN:
#endif
#ifdef ECONNREFUSED
  case ECONNREFUSED:
#endif
#ifdef ECONNRESET
  case ECONNRESET:
#endif
#ifdef ENETUNREACH
  case ENETUNREACH:
#endif
#ifdef EHOSTDOWN
  case EHOSTDOWN:
#endif
    /* Do nothing */
    break ;
  default:
    serror("udp_recv", Nothing) ;
    break ;
  }
}


value skt_udp_recv(		/* ML */
        value sock_v,
	value buf_v,
	value ofs_v,
	value len_v
) {
  int ret ;
  int len ;
  int ofs ;
  SKTTRACE;
  ofs = Long_val(ofs_v) ;
  len = Long_val(len_v) ;

#ifdef _WIN32
  /* Windows/NT seems to prefer that we use recvfrom(), even though recv()
   * should be ok.
   */
  ret = recvfrom(Socket_val(sock_v), &Byte(buf_v, ofs), len, 0, NULL, NULL) ;
#else
  ret = recv(Socket_val(sock_v), &Byte(buf_v, ofs), len, 0) ;
#endif

  /* First, check if everything is OK and quickly return if so.
   * Note that ((ret&3)==0) implies (ret!=(-1)).
   */
  if ((ret < len) && ((ret & 3) == 0)) {
    assert(ret != -1) ;
    return Val_int(ret) ;
  }

  /* Check for truncated messages.
   */
  if (ret == len) {
    fprintf(stderr,"SOCKET:udp_recv:warning:got packet that is maximum size (probably truncated), dropping (len=%d)\n",ret) ;
    return Val_int(0) ;
  }

  /* Check for non-4byte-word aligned messages.
   */
  if (ret != -1 && (ret & 3)) {
    fprintf(stderr,"SOCKET:udp_recv:warning:got packet that is not 4-byte aligned, dropping (len=%d)\n",ret) ;
    return Val_int(0) ;
  }

  /* Handle remaining errors.
   */
  assert(ret == -1) ;
  skt_recv_error() ;
  return Val_int(0) ;
}

#else

value skt_recv() { invalid_argument("recv not implemented"); }
value skt_udp_recv() { invalid_argument("udp_recv not implemented"); }
value skt_send() { invalid_argument("send not implemented"); }

#endif