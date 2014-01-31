# -------------------------------------------------------------------
# EPTOOLS_EXT
# -------------------------------------------------------------------
# Cython code wrapping external C++ functions.
# Calls functions from src/eptools/wrap (eptools part)
# Author: Matthias Seeger
# -------------------------------------------------------------------

# TODO:
# - Define specific exception(s). Right now, TypeError is used everywhere
# - Add docstring's (best: use reStructured text)

import cython
import numpy as np
cimport numpy as np

# We get pointers to BLAS functions from scipy:
# See mail.scipy.org/pipermail/numpy-discussion/2013-February/065576.html
import scipy
from cpython cimport PyCObject_AsVoidPtr
__import__('scipy.linalg.blas')

# Declarations: Pointer_to_function types for BLAS functions. Required by
# eptwrap_choluprk1, eptwrap_choldnrk1

cdef extern from "src/eptools/wrap/matrix_types.h":
    ctypedef int blasint_t

    ctypedef void (* dcopy_type) (blasint_t* n,double* x,blasint_t* incx,
                                  double* y,blasint_t* incy)

    ctypedef void (* dscal_type) (blasint_t* n,double* alpha,double* x,
                                  blasint_t* incx)

    ctypedef double (* ddot_type) (blasint_t* n,double* a,blasint_t* lda,
                                   double* b,blasint_t* ldb)

    ctypedef void (* daxpy_type) (blasint_t *n,double* alpha,double* x,
                                  blasint_t* incx,double* y,blasint_t* incy)

    ctypedef void (* drotg_type) (double* a,double* b,double* c,double* s)

    ctypedef void (* drot_type) (blasint_t* n,double* x,blasint_t* incx,
                                 double* y,blasint_t* incy,double* c,double* s)

    ctypedef void (* dtrsv_type) (char* uplo,char* trans,char* diag,
                                  blasint_t* n,double* a,blasint_t* lda,
                                  double* x,blasint_t* incx)

    ctypedef struct fst_matrix:
        double* buff
        int m,n
        int stride
        char strcode[4]

# Declarations: C wrapper functions

cdef extern from "src/eptools/wrap/eptwrap_epupdate_parallel.h":
    void eptwrap_epupdate_parallel(int ain,int aout,int* potids,int npotids,
                                   int* numpot,int nnumpot,double* parvec,
                                   int nparvec,int* parshrd,int nparshrd,
                                   double* cmu,int ncmu,double* crho,int ncrho,
                                   int* updind,int nupdind,int* rstat,
                                   int nrstat,double* alpha,int nalpha,
                                   double* nu,int nnu,double* logz,int nlogz,
                                   int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_getpotid.h":
    void eptwrap_getpotid(int ain,int aout,char* name,int* pid,int* errcode,
                          char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_getpotname.h":
    void eptwrap_getpotname(int ain,int aout,int pid,char** name,int* errcode,
                            char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_fact_compmarginals.h":
    void eptwrap_fact_compmarginals(int ain,int aout,int n,int m,int* rp_rowind,
                                    int nrp_rowind,int* rp_colind,
                                    int nrp_colind,double* rp_bvals,
                                    int nrp_bvals,double* rp_pi,int nrp_pi,
                                    double* rp_beta,int nrp_beta,
                                    double* margpi,int nmargpi,
                                    double* margbeta,int nmargbeta,
                                    int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_fact_compmaxpi.h":
    void eptwrap_fact_compmaxpi(int ain,int aout,int n,int m,int* rp_rowind,
                                int nrp_rowind,int* rp_colind,int nrp_colind,
                                double* rp_bvals,int nrp_bvals,double* rp_pi,
                                int nrp_pi,double* rp_beta,int nrp_beta,
                                int sd_k,int* sd_subind,int nsd_subind,
                                int sd_subexcl,int* sd_numvalid,
                                int nsd_numvalid,int* sd_topind,int nsd_topind,
                                double* sd_topval,int nsd_topval,int* errcode,
                                char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_fact_sequpdates.h":
    void eptwrap_fact_sequpdates(int ain,int aout,int n,int m,int* updjind,
                                 int nupdjind,int* pm_potids,int npm_potids,
				 int* pm_numpot,int npm_numpot,
                                 double* pm_parvec,int npm_parvec,
                                 int* pm_parshrd,int npm_parshrd,
                                 int* rp_rowind,int nrp_rowind,int* rp_colind,
                                 int nrp_colind,double* rp_bvals,int nrp_bvals,
                                 double* rp_pi,int nrp_pi,double* rp_beta,
                                 int nrp_beta,double* margpi,int nmargpi,
                                 double* margbeta,int nmargbeta,
                                 double piminthres,double dampfact,
                                 int* sd_numvalid,int nsd_numvalid,
                                 int* sd_topind,int nsd_topind,
                                 double* sd_topval,int nsd_topval,
                                 int* sd_subind,int nsd_subind,int sd_subexcl,
                                 int* rstat,int nrstat,double* delta,
                                 int ndelta,double* sd_dampfact,
                                 int nsd_dampfact,int* sd_nupd,int* sd_nrec,
                                 int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_potmanager_isvalid.h":
    void eptwrap_potmanager_isvalid(int ain,int aout,int* potids,int npotids,
                                    int* numpot,int nnumpot,double* parvec,
                                    int nparvec,int* parshrd,int nparshrd,
                                    int posoff,char** retstr,int* errcode,
                                    char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_epupdate_single.h":
    void eptwrap_epupdate_single1(int ain,int aout,int pid,double* pars,
                                  int npars,double cmu,double crho,int* rstat,
                                  double* alpha,double* nu,double* logz,
                                  int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_epupdate_single.h":
    void eptwrap_epupdate_single2(int ain,int aout,char* pname,double* pars,
                                  int npars,double cmu,double crho,int* rstat,
                                  double* alpha,double* nu,double* logz,
                                  int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_epupdate_single.h":
    void eptwrap_epupdate_single3(int ain,int aout,int* potids,int npotids,
                                  int* numpot,int nnumpot,double* parvec,
                                  int nparvec,int* parshrd,int nparshrd,
                                  int pind,double cmu,double crho,int* rstat,
                                  double* alpha,double* nu,double* logz,
                                  int* errcode,char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_choluprk1.h":
    void eptwrap_choluprk1(int ain,int aout,fst_matrix* lmat,double* vvec,
                           int nvvec,double* cvec,int ncvec,double* svec,
                           int nsvec,double* wkvec,int nwkvec,fst_matrix* zmat,
                           double* yvec,int nyvec,int* stat,dcopy_type f_dcopy,
                           drotg_type f_drotg,drot_type f_drot,int* errcode,
                           char* errstr)

cdef extern from "src/eptools/wrap/eptwrap_choldnrk1.h":
    void eptwrap_choldnrk1(int ain,int aout,fst_matrix* lmat,double* vvec,
                           int nvvec,double* cvec,int ncvec,double* svec,
                           int nsvec,double* wkvec,int nwkvec,int isp,
                           fst_matrix* zmat,double* yvec,int nyvec,int* stat,
                           dcopy_type f_dcopy,dtrsv_type f_dtrsv,
                           ddot_type f_ddot,drotg_type f_drotg,
                           drot_type f_drot,dscal_type f_dscal,
                           daxpy_type f_daxpy,int* errcode,char* errstr)

# Cython functions

# rstat, alpha, nu, logz (optional) are return arguments (contiguous vectors
# of same size as cmu, rstat is int32, others are double).
@cython.boundscheck(False)
@cython.wraparound(False)
def epupdate_parallel(np.ndarray[int,ndim=1] potids not None,
                      np.ndarray[int,ndim=1] numpot not None,
                      np.ndarray[np.double_t,ndim=1] parvec not None,
                      np.ndarray[int,ndim=1] parshrd not None,
                      np.ndarray[np.double_t,ndim=1] cmu not None,
                      np.ndarray[np.double_t,ndim=1] crho not None,
                      np.ndarray[int,ndim=1] rstat not None,
                      np.ndarray[np.double_t,ndim=1] alpha not None,
                      np.ndarray[np.double_t,ndim=1] nu not None,
                      np.ndarray[np.double_t,ndim=1] logz = None,
                      np.ndarray[int,ndim=1] updind = None):
    cdef int rsz, errcode
    cdef char errstr[512]
    # Ensure that input/output arguments are contiguous
    rsz = cmu.shape[0]
    if not (rstat.flags.c_contiguous and rstat.shape[0]==rsz):
        # HIER: Define own exception, say EptwrapError
        raise TypeError('RSTAT must be contiguous array of size of CMU')
    if not (alpha.flags.c_contiguous and alpha.shape[0]==rsz):
        # HIER: Define own exception, say EptwrapError
        raise TypeError('ALPHA must be contiguous array of size of CMU')
    if not (nu.flags.c_contiguous and nu.shape[0]==rsz):
        # HIER: Define own exception, say EptwrapError
        raise TypeError('NU must be contiguous array of size of CMU')
    if not (logz is None or (logz.flags.c_contiguous and logz.shape[0]==rsz)):
        # HIER: Define own exception, say EptwrapError
        raise TypeError('LOGZ must be contiguous array of size of CMU')
    potids = np.ascontiguousarray(potids)
    numpot = np.ascontiguousarray(numpot)
    parvec = np.ascontiguousarray(parvec)
    parshrd = np.ascontiguousarray(parshrd)
    cmu = np.ascontiguousarray(cmu)
    crho = np.ascontiguousarray(crho)
    # Create return arguments
    # NOTE: They are now passed as arguments (more efficient)
    #rsz = cmu.shape[0]
    #cdef np.ndarray[int,ndim=1] rstat = np.zeros(rsz,dtype=np.int32)
    #cdef np.ndarray[np.double_t,ndim=1] alpha = np.zeros(rsz,dtype=np.double)
    #cdef np.ndarray[np.double_t,ndim=1] nu = np.zeros(rsz,dtype=np.double)
    #cdef np.ndarray[np.double_t,ndim=1] logz = np.zeros(rsz,dtype=np.double)
    # Call C function
    if updind is None:
        if logz is None:
            eptwrap_epupdate_parallel(6,3,&potids[0],potids.shape[0],&numpot[0],
                                      numpot.shape[0],&parvec[0],
                                      parvec.shape[0],&parshrd[0],
                                      parshrd.shape[0],&cmu[0],cmu.shape[0],
                                      &crho[0],crho.shape[0],NULL,0,&rstat[0],
                                      rstat.shape[0],&alpha[0],alpha.shape[0],
                                      &nu[0],nu.shape[0],NULL,0,&errcode,errstr)
        else:
            eptwrap_epupdate_parallel(6,4,&potids[0],potids.shape[0],&numpot[0],
                                      numpot.shape[0],&parvec[0],
                                      parvec.shape[0],&parshrd[0],
                                      parshrd.shape[0],&cmu[0],cmu.shape[0],
                                      &crho[0],crho.shape[0],NULL,0,&rstat[0],
                                      rstat.shape[0],&alpha[0],alpha.shape[0],
                                      &nu[0],nu.shape[0],&logz[0],
                                      logz.shape[0],&errcode,errstr)
    else:
        updind = np.ascontiguousarray(updind)
        if logz is None:
            eptwrap_epupdate_parallel(7,3,&potids[0],potids.shape[0],&numpot[0],
                                      numpot.shape[0],&parvec[0],
                                      parvec.shape[0],&parshrd[0],
                                      parshrd.shape[0],&cmu[0],cmu.shape[0],
                                      &crho[0],crho.shape[0],&updind[0],
                                      updind.shape[0],&rstat[0],rstat.shape[0],
                                      &alpha[0],alpha.shape[0],&nu[0],
                                      nu.shape[0],NULL,0,&errcode,errstr)
        else:
            eptwrap_epupdate_parallel(7,4,&potids[0],potids.shape[0],&numpot[0],
                                      numpot.shape[0],&parvec[0],
                                      parvec.shape[0],&parshrd[0],
                                      parshrd.shape[0],&cmu[0],cmu.shape[0],
                                      &crho[0],crho.shape[0],&updind[0],
                                      updind.shape[0],&rstat[0],rstat.shape[0],
                                      &alpha[0],alpha.shape[0],&nu[0],
                                      nu.shape[0],&logz[0],logz.shape[0],
                                      &errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)

def getpotid(bytes name not None):
    cdef int errcode, pid
    cdef char errstr[512]
    # Call C function
    eptwrap_getpotid(1,1,<char*>name,&pid,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return pid

def getpotname(int pid):
    cdef int errcode
    cdef char errstr[512]
    cdef char* name
    # Call C function
    eptwrap_getpotname(1,1,pid,&name,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return <bytes>name

@cython.boundscheck(False)
@cython.wraparound(False)
def fact_compmarginals(int n,int m,np.ndarray[int,ndim=1] rp_rowind not None,
                       np.ndarray[int,ndim=1] rp_colind not None,
                       np.ndarray[np.double_t,ndim=1] rp_bvals not None,
                       np.ndarray[np.double_t,ndim=1] rp_pi not None,
                       np.ndarray[np.double_t,ndim=1] rp_beta not None,
                       np.ndarray[np.double_t,ndim=1] margpi not None,
                       np.ndarray[np.double_t,ndim=1] margbeta not None):
    cdef int errcode
    cdef char errstr[512]
    # Ensure that input/output arguments are contiguous
    if not margpi.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('MARGPI must be contiguous array')
    if not margbeta.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('MARGBETA must be contiguous array')
    rp_rowind = np.ascontiguousarray(rp_rowind)
    rp_colind = np.ascontiguousarray(rp_colind)
    rp_bvals = np.ascontiguousarray(rp_bvals)
    rp_pi = np.ascontiguousarray(rp_pi)
    rp_beta = np.ascontiguousarray(rp_beta)
    # Call C function
    eptwrap_fact_compmarginals(9,0,n,m,&rp_rowind[0],rp_rowind.shape[0],
                               &rp_colind[0],rp_colind.shape[0],&rp_bvals[0],
                               rp_bvals.shape[0],&rp_pi[0],rp_pi.shape[0],
                               &rp_beta[0],rp_beta.shape[0],&margpi[0],
                               margpi.shape[0],&margbeta[0],margbeta.shape[0],
                               &errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)

@cython.boundscheck(False)
@cython.wraparound(False)
def fact_compmaxpi(int n,int m,np.ndarray[int,ndim=1] rp_rowind not None,
                   np.ndarray[int,ndim=1] rp_colind not None,
                   np.ndarray[np.double_t,ndim=1] rp_bvals not None,
                   np.ndarray[np.double_t,ndim=1] rp_pi not None,
                   np.ndarray[np.double_t,ndim=1] rp_beta not None,
                   int sd_k,np.ndarray[int,ndim=1] sd_subind = None,
                   int sd_subexcl = 0):
    cdef int errcode, rsz
    cdef char errstr[512]
    # Ensure that input arguments are contiguous
    rp_rowind = np.ascontiguousarray(rp_rowind)
    rp_colind = np.ascontiguousarray(rp_colind)
    rp_bvals = np.ascontiguousarray(rp_bvals)
    rp_pi = np.ascontiguousarray(rp_pi)
    rp_beta = np.ascontiguousarray(rp_beta)
    # Create return arguments
    if sd_k<2:
        # HIER: Define own exception, or use appropriate one!
        raise TypeError('SD_K: Must be >1')
    if n<1:
        # HIER: Define own exception, or use appropriate one!
        raise TypeError('N: Must be positive')
    rsz = n*(sd_k+1)
    cdef np.ndarray[int,ndim=1] sd_numvalid = np.zeros(n,dtype=np.int32)
    cdef np.ndarray[int,ndim=1] sd_topind = np.zeros(rsz,dtype=np.int32)
    cdef np.ndarray[np.double_t,ndim=1] sd_topval = \
        np.zeros(rsz,dtype=np.double)
    # Call C function
    if sd_subind is None:
        eptwrap_fact_compmaxpi(8,3,n,m,&rp_rowind[0],rp_rowind.shape[0],
                               &rp_colind[0],rp_colind.shape[0],&rp_bvals[0],
                               rp_bvals.shape[0],&rp_pi[0],rp_pi.shape[0],
                               &rp_beta[0],rp_beta.shape[0],sd_k,NULL,0,
                               sd_subexcl,&sd_numvalid[0],sd_numvalid.shape[0],
                               &sd_topind[0],sd_topind.shape[0],&sd_topval[0],
                               sd_topval.shape[0],&errcode,errstr)
    else:
        sd_subind = np.ascontiguousarray(sd_subind)
        eptwrap_fact_compmaxpi(10,3,n,m,&rp_rowind[0],rp_rowind.shape[0],
                               &rp_colind[0],rp_colind.shape[0],&rp_bvals[0],
                               rp_bvals.shape[0],&rp_pi[0],rp_pi.shape[0],
                               &rp_beta[0],rp_beta.shape[0],sd_k,&sd_subind[0],
                               sd_subind.shape[0],sd_subexcl,&sd_numvalid[0],
                               sd_numvalid.shape[0],&sd_topind[0],
                               sd_topind.shape[0],&sd_topval[0],
                               sd_topval.shape[0],&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return (sd_numvalid,sd_topind,sd_topval)

# NOTE: sd_nupd, sd_nrec are returned only if rstat, delta, sd_dampfact and
# sd_numvalid are all given
@cython.boundscheck(False)
@cython.wraparound(False)
def fact_sequpdates(int n,int m,np.ndarray[int,ndim=1] updjind not None,
                    np.ndarray[int,ndim=1] pm_potids not None,
                    np.ndarray[int,ndim=1] pm_numpot not None,
                    np.ndarray[np.double_t,ndim=1] pm_parvec not None,
                    np.ndarray[int,ndim=1] pm_parshrd not None,
                    np.ndarray[int,ndim=1] rp_rowind not None,
                    np.ndarray[int,ndim=1] rp_colind not None,
                    np.ndarray[np.double_t,ndim=1] rp_bvals not None,
                    np.ndarray[np.double_t,ndim=1] rp_pi not None,
                    np.ndarray[np.double_t,ndim=1] rp_beta not None,
                    np.ndarray[np.double_t,ndim=1] margpi not None,
                    np.ndarray[np.double_t,ndim=1] margbeta not None,
                    double piminthres,double dampfact = 0.,
                    np.ndarray[int,ndim=1] rstat = None,
                    np.ndarray[np.double_t,ndim=1] delta = None,
                    np.ndarray[int,ndim=1] sd_numvalid = None,
                    np.ndarray[int,ndim=1] sd_topind = None,
                    np.ndarray[np.double_t,ndim=1] sd_topval = None,
                    np.ndarray[int,ndim=1] sd_subind = None,
                    int sd_subexcl = 0,
                    np.ndarray[np.double_t,ndim=1] sd_dampfact = None):
    cdef int errcode, rsz, sd_nupd, sd_nrec, aout, ain
    cdef char errstr[512]
    # Ensure that input/output arguments are contiguous
    updjind = np.ascontiguousarray(updjind)
    pm_potids = np.ascontiguousarray(pm_potids)
    pm_numpot = np.ascontiguousarray(pm_numpot)
    pm_parvec = np.ascontiguousarray(pm_parvec)
    pm_parshrd = np.ascontiguousarray(pm_parshrd)
    rp_rowind = np.ascontiguousarray(rp_rowind)
    rp_colind = np.ascontiguousarray(rp_colind)
    rp_bvals = np.ascontiguousarray(rp_bvals)
    if not rp_pi.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('RP_PI must be contiguous array')
    if not rp_beta.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('RP_BETA must be contiguous array')
    if not margpi.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('MARGPI must be contiguous array')
    if not margbeta.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('MARGBETA must be contiguous array')
    if sd_numvalid is not None:
        if not sd_numvalid.flags.c_contiguous:
            # HIER: Define own exception, say EptwrapError
            raise TypeError('SD_NUMVALID must be contiguous array')
        if sd_topind is None or not sd_topind.flags.c_contiguous:
            # HIER: Define own exception, or use appropriate one!
            raise TypeError('SD_TOPIND must be contiguous array')
        if sd_topval is None or not sd_topval.flags.c_contiguous:
            # HIER: Define own exception, or use appropriate one!
            raise TypeError('SD_TOPVAL must be contiguous array')
    # Return arguments
    rsz = updjind.shape[0]
    if rsz<1:
        # HIER: Define own exception, or use appropriate one!
        raise TypeError('UPDJIND must not be empty')
    if not (rstat is None or rstat.flags.c_contiguous):
        raise TypeError('RSTAT must be contiguous array')
    if not (delta is None or delta.flags.c_contiguous):
        raise TypeError('DELTA must be contiguous array')
    if not (sd_numvalid is None or sd_dampfact is None or
            sd_dampfact.flags.c_contiguous):
        raise TypeError('SD_NUMVALID must be contiguous array')
    aout = 0
    if rstat is not None:
        aout = 1
        if delta is not None:
            aout = 2
            if not (sd_numvalid is None or sd_dampfact is None):
                aout = 5
    # Call C function
    if sd_numvalid is None:
        eptwrap_fact_sequpdates(16,aout,n,m,&updjind[0],updjind.shape[0],
                                &pm_potids[0],pm_potids.shape[0],&pm_numpot[0],
                                pm_numpot.shape[0],&pm_parvec[0],
                                pm_parvec.shape[0],&pm_parshrd[0],
                                pm_parshrd.shape[0],&rp_rowind[0],
                                rp_rowind.shape[0],&rp_colind[0],
                                rp_colind.shape[0],&rp_bvals[0],
                                rp_bvals.shape[0],&rp_pi[0],rp_pi.shape[0],
                                &rp_beta[0],rp_beta.shape[0],&margpi[0],
                                margpi.shape[0],&margbeta[0],margbeta.shape[0],
                                piminthres,dampfact,NULL,0,NULL,0,NULL,0,NULL,
                                0,0,&rstat[0] if aout>0 else NULL,
                                rstat.shape[0] if aout>0 else 0,
                                &delta[0] if aout>1 else NULL,
                                delta.shape[0] if aout>1 else 0,NULL,0,NULL,
                                NULL,&errcode,errstr)
    else:
        # With selective damping
        if sd_subind is None:
            ain = 19
        else:
            sd_subind = np.ascontiguousarray(sd_subind)
            ain = 21
        eptwrap_fact_sequpdates(ain,aout,n,m,&updjind[0],updjind.shape[0],
                                &pm_potids[0],pm_potids.shape[0],&pm_numpot[0],
                                pm_numpot.shape[0],&pm_parvec[0],
                                pm_parvec.shape[0],&pm_parshrd[0],
                                pm_parshrd.shape[0],&rp_rowind[0],
                                rp_rowind.shape[0],&rp_colind[0],
                                rp_colind.shape[0],&rp_bvals[0],
                                rp_bvals.shape[0],&rp_pi[0],rp_pi.shape[0],
                                &rp_beta[0],rp_beta.shape[0],&margpi[0],
                                margpi.shape[0],&margbeta[0],margbeta.shape[0],
                                piminthres,dampfact,&sd_numvalid[0],
                                sd_numvalid.shape[0],&sd_topind[0],
                                sd_topind.shape[0],&sd_topval[0],
                                sd_topval.shape[0],
                                &sd_subind[0] if ain>19 else NULL,
                                sd_subind.shape[0] if ain>19 else 0,
                                sd_subexcl if ain>20 else 0,
                                &rstat[0] if aout>0 else NULL,
                                rstat.shape[0] if aout>0 else 0,
                                &delta[0] if aout>1 else NULL,
                                delta.shape[0] if aout>1 else 0,
                                &sd_dampfact[0] if aout>2 else NULL,
                                sd_dampfact.shape[0] if aout>2 else 0,&sd_nupd,
                                &sd_nrec,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    if aout>2:
        return (sd_nupd,sd_nrec)

@cython.boundscheck(False)
@cython.wraparound(False)
def potmanager_isvalid(np.ndarray[int,ndim=1] potids not None,
                       np.ndarray[int,ndim=1] numpot not None,
                       np.ndarray[np.double_t,ndim=1] parvec not None,
                       np.ndarray[int,ndim=1] parshrd not None,
                       int posoff = 0):
    cdef int errcode
    cdef char errstr[512]
    cdef char* retstr
    # Ensure that input arguments are contiguous
    potids = np.ascontiguousarray(potids)
    numpot = np.ascontiguousarray(numpot)
    parvec = np.ascontiguousarray(parvec)
    parshrd = np.ascontiguousarray(parshrd)
    # Call C function
    eptwrap_potmanager_isvalid(5,1,&potids[0],potids.shape[0],&numpot[0],
                               numpot.shape[0],&parvec[0],parvec.shape[0],
                               &parshrd[0],parshrd.shape[0],posoff,&retstr,
                               &errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return <bytes>retstr

def epupdate_single(pid,np.ndarray[np.double_t,ndim=1] pars not None,
                    double cmu,double crho):
    cdef int errcode, rstat
    cdef char errstr[512]
    cdef double alpha, nu, logz
    # Ensure that input arguments are contiguous
    pars = np.ascontiguousarray(pars)
    # Call C function
    if isinstance(pid,str):
        eptwrap_epupdate_single2(4,4,<char*>pid,&pars[0],pars.shape[0],cmu,
                                 crho,&rstat,&alpha,&nu,&logz,&errcode,errstr)
    else:
        eptwrap_epupdate_single1(4,4,<int>pid,&pars[0],pars.shape[0],cmu,crho,
                                 &rstat,&alpha,&nu,&logz,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return (rstat,alpha,nu,logz)

@cython.boundscheck(False)
@cython.wraparound(False)
def epupdate_single_pman(np.ndarray[int,ndim=1] potids not None,
                         np.ndarray[int,ndim=1] numpot not None,
                         np.ndarray[np.double_t,ndim=1] parvec not None,
                         np.ndarray[int,ndim=1] parshrd not None,
                         int pind,double cmu,double crho):
    cdef int errcode, rstat
    cdef char errstr[512]
    cdef double alpha, nu, logz
    # Ensure that input arguments are contiguous
    potids = np.ascontiguousarray(potids)
    numpot = np.ascontiguousarray(numpot)
    parvec = np.ascontiguousarray(parvec)
    parshrd = np.ascontiguousarray(parshrd)
    # Call C function
    eptwrap_epupdate_single3(7,4,&potids[0],potids.shape[0],&numpot[0],
                             numpot.shape[0],&parvec[0],parvec.shape[0],
                             &parshrd[0],parshrd.shape[0],pind,cmu,crho,
                             &rstat,&alpha,&nu,&logz,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return (rstat,alpha,nu,logz)

@cython.boundscheck(False)
@cython.wraparound(False)
def choluprk1(np.ndarray[np.double_t,ndim=2] l not None,bytes luplo not None,
              np.ndarray[np.double_t,ndim=1] vec not None,
              np.ndarray[np.double_t,ndim=1] cvec not None,
              np.ndarray[np.double_t,ndim=1] svec not None,
              np.ndarray[np.double_t,ndim=1] workv not None,
              np.ndarray[np.double_t,ndim=2] z = None,
              np.ndarray[np.double_t,ndim=1] y = None):
    cdef int errcode, stat
    cdef char errstr[512]
    # Ensure that input/output arguments are contiguous
    if not l.flags.f_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('L must be Fortran contiguous (column-major)')
    if not vec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('VEC must be contiguous array')
    if not cvec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('CVEC must be contiguous array')
    if not svec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('SVEC must be contiguous array')
    if not workv.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('WORKV must be contiguous array')
    # We use fst_matrix transfer type
    cdef fst_matrix lmat, zmat
    lmat.buff = &l[0,0]
    lmat.m, lmat.n = l.shape[0], l.shape[1]
    lmat.stride = l.shape[0]
    lmat.strcode[0] = luplo[0]; lmat.strcode[1] = 0
    lmat.strcode[2] = 'N'; lmat.strcode[3] = 0
    # Get BLAS function pointers from scipy
    cdef dcopy_type f_dcopy = <dcopy_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.dcopy._cpointer)
    cdef drotg_type f_drotg = <drotg_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.drotg._cpointer)
    cdef drot_type f_drot   = <drot_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.drot._cpointer)
    # Call C function
    if z is None:
        eptwrap_choluprk1(5,1,&lmat,&vec[0],vec.shape[0],&cvec[0],
                          cvec.shape[0],&svec[0],svec.shape[0],&workv[0],
                          workv.shape[0],NULL,NULL,0,&stat,f_dcopy,f_drotg,
                          f_drot,&errcode,errstr)
    else:
        if not z.flags.f_contiguous:
            # HIER: Define own exception, say EptwrapError
            raise TypeError('Z must be Fortran contiguous (column-major)')
        if not y.flags.c_contiguous:
            # HIER: Define own exception, say EptwrapError
            raise TypeError('Y must be contiguous array')
        zmat.buff = &z[0,0]
        zmat.m, zmat.n = z.shape[0], z.shape[1]
        zmat.stride = z.shape[0]
        # Not used:
        zmat.strcode[0] = ' '; zmat.strcode[1] = 0
        zmat.strcode[2] = ' '; zmat.strcode[3] = 0
        eptwrap_choluprk1(7,1,&lmat,&vec[0],vec.shape[0],&cvec[0],
                          cvec.shape[0],&svec[0],svec.shape[0],&workv[0],
                          workv.shape[0],&zmat,&y[0],y.shape[0],&stat,
                          f_dcopy,f_drotg,f_drot,&errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return stat

# NOTE: The ISP argument, which can be used for the MEX version, is not
# exposed here, but is fixed to 1 (so VEC must contain the p vector
# already). This is because BLAS dtrsv cannot be accessed via scipy
@cython.boundscheck(False)
@cython.wraparound(False)
def choldnrk1(np.ndarray[np.double_t,ndim=2] l not None,bytes luplo not None,
              np.ndarray[np.double_t,ndim=1] vec not None,
              np.ndarray[np.double_t,ndim=1] cvec not None,
              np.ndarray[np.double_t,ndim=1] svec not None,
              np.ndarray[np.double_t,ndim=1] workv not None,
              np.ndarray[np.double_t,ndim=2] z = None,
              np.ndarray[np.double_t,ndim=1] y = None):
    cdef int errcode, stat, isp
    cdef char errstr[512]
    isp = 1
    # Ensure that input/output arguments are contiguous
    if not l.flags.f_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('L must be Fortran contiguous (column-major)')
    if not vec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('VEC must be contiguous array')
    if not cvec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('CVEC must be contiguous array')
    if not svec.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('SVEC must be contiguous array')
    if not workv.flags.c_contiguous:
        # HIER: Define own exception, say EptwrapError
        raise TypeError('WORKV must be contiguous array')
    # We use fst_matrix transfer type
    cdef fst_matrix lmat, zmat
    lmat.buff = &l[0,0]
    lmat.m, lmat.n = l.shape[0], l.shape[1]
    lmat.stride = l.shape[0]
    lmat.strcode[0] = luplo[0]; lmat.strcode[1] = 0
    lmat.strcode[2] = 'N'; lmat.strcode[3] = 0
    # Get BLAS function pointers from scipy
    cdef dcopy_type f_dcopy = <dcopy_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.dcopy._cpointer)
    cdef ddot_type f_ddot   = <ddot_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.ddot._cpointer)
    cdef drotg_type f_drotg = <drotg_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.drotg._cpointer)
    cdef drot_type f_drot   = <drot_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.drot._cpointer)
    cdef dscal_type f_dscal = <dscal_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.dscal._cpointer)
    cdef daxpy_type f_daxpy = <daxpy_type>PyCObject_AsVoidPtr( \
                                scipy.linalg.blas.cblas.daxpy._cpointer)
    # Call C function
    if z is None:
        eptwrap_choldnrk1(6,1,&lmat,&vec[0],vec.shape[0],&cvec[0],
                          cvec.shape[0],&svec[0],svec.shape[0],&workv[0],
                          workv.shape[0],isp,NULL,NULL,0,&stat,f_dcopy,NULL,
                          f_ddot,f_drotg,f_drot,f_dscal,f_daxpy,&errcode,
                          errstr)
    else:
        if not z.flags.f_contiguous:
            # HIER: Define own exception, say EptwrapError
            raise TypeError('Z must be Fortran contiguous (column-major)')
        if not y.flags.c_contiguous:
            # HIER: Define own exception, say EptwrapError
            raise TypeError('Y must be contiguous array')
        zmat.buff = &z[0,0]
        zmat.m, zmat.n = z.shape[0], z.shape[1]
        zmat.stride = z.shape[0]
        # Not used:
        zmat.strcode[0] = ' '; zmat.strcode[1] = 0
        zmat.strcode[2] = ' '; zmat.strcode[3] = 0
        eptwrap_choldnrk1(8,1,&lmat,&vec[0],vec.shape[0],&cvec[0],
                          cvec.shape[0],&svec[0],svec.shape[0],&workv[0],
                          workv.shape[0],isp,&zmat,&y[0],y.shape[0],&stat,
                          f_dcopy,NULL,f_ddot,f_drotg,f_drot,f_dscal,f_daxpy,
                          &errcode,errstr)
    # Check for error, raise exception
    if errcode != 0:
        # HIER: Define own exception, say EptwrapError
        raise TypeError(<bytes>errstr)
    return stat
