/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _RAND_H_RPCGEN
#define _RAND_H_RPCGEN

#include <rpc/rpc.h>


#ifdef __cplusplus
extern "C" {
#endif


#define RAND_PROG 4893625
#define RAND_VERS 1

#if defined(__STDC__) || defined(__cplusplus)
#define INITIALIZE_RANDOM 1
extern  void * initialize_random_1(long *, CLIENT *);
extern  void * initialize_random_1_svc(long *, struct svc_req *);
#define GET_NEXT_RANDOM 2
extern  double * get_next_random_1(void *, CLIENT *);
extern  double * get_next_random_1_svc(void *, struct svc_req *);
extern int rand_prog_1_freeresult (SVCXPRT *, xdrproc_t, caddr_t);

#else /* K&R C */
#define INITIALIZE_RANDOM 1
extern  void * initialize_random_1();
extern  void * initialize_random_1_svc();
#define GET_NEXT_RANDOM 2
extern  double * get_next_random_1();
extern  double * get_next_random_1_svc();
extern int rand_prog_1_freeresult ();
#endif /* K&R C */

#ifdef __cplusplus
}
#endif

#endif /* !_RAND_H_RPCGEN */
