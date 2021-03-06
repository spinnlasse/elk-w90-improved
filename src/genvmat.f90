
! Copyright (C) 2007 J. K. Dewhurst, S. Sharma and E. K. U. Gross.
! This file is distributed under the terms of the GNU General Public License.
! See the file COPYING for license details.

subroutine genvmat(vmt,vir,vmat)
! generates potential matrix elements for all states and k-points
use modmain
use modmpi
use modomp
implicit none
! arguments
real(8), intent(in) :: vmt(npmtmax,natmtot),vir(ngtot)
complex(8), intent(out) :: vmat(nstsv,nstsv,nkpt)
! local variables
integer ik,ist,ispn
integer is,ias,n,lp,nthd
! automatic arrays
integer idx(nstsv)
! allocatable arrays
real(8), allocatable :: vmt1(:,:),vir1(:),rfmt(:)
complex(8), allocatable :: apwalm(:,:,:,:,:),evecfv(:,:),evecsv(:,:)
complex(8), allocatable :: wfmt(:,:,:,:),wfir(:,:,:)
! allocate local arrays
allocate(vmt1(npcmtmax,natmtot),vir1(ngtot))
! convert muffin-tin potential to spherical coordinates
call omp_hold(natmtot,nthd)
!$OMP PARALLEL DEFAULT(SHARED) &
!$OMP PRIVATE(rfmt,is) &
!$OMP NUM_THREADS(nthd)
!$OMP DO
do ias=1,natmtot
  allocate(rfmt(npcmtmax))
  is=idxis(ias)
  call rfmtftoc(nrmt(is),nrmti(is),vmt(:,ias),rfmt)
  call rbsht(nrcmt(is),nrcmti(is),rfmt,vmt1(:,ias))
  deallocate(rfmt)
end do
!$OMP END DO
!$OMP END PARALLEL
call omp_free(nthd)
! multiply interstitial potential by characteristic function
vir1(:)=vir(:)*cfunir(:)
! index to all states
do ist=1,nstsv
  idx(ist)=ist
end do
! loop over k-points
call omp_hold(nkpt/np_mpi,nthd)
!$OMP PARALLEL DEFAULT(SHARED) &
!$OMP PRIVATE(apwalm,evecfv,evecsv) &
!$OMP PRIVATE(wfmt,wfir,ispn) &
!$OMP NUM_THREADS(nthd)
!$OMP DO
do ik=1,nkpt
! distribute among MPI processes
  if (mod(ik-1,np_mpi).ne.lp_mpi) cycle
  allocate(apwalm(ngkmax,apwordmax,lmmaxapw,natmtot,nspnfv))
  allocate(evecfv(nmatmax,nstfv),evecsv(nstsv,nstsv))
  allocate(wfmt(npcmtmax,natmtot,nspinor,nstsv))
  allocate(wfir(ngkmax,nspinor,nstsv))
! find the matching coefficients
  do ispn=1,nspnfv
    call match(ngk(ispn,ik),gkc(:,ispn,ik),tpgkc(:,:,ispn,ik), &
     sfacgk(:,:,ispn,ik),apwalm(:,:,:,:,ispn))
  end do
! get the eigenvectors from file
  call getevecfv(filext,ik,vkl(:,ik),vgkl(:,:,:,ik),evecfv)
  call getevecsv(filext,ik,vkl(:,ik),evecsv)
! calculate the wavefunctions for all states of the input k-point
  call genwfsv(.false.,.true.,nstsv,idx,ngridg,igfft,ngk(:,ik),igkig(:,:,ik), &
   apwalm,evecfv,evecsv,wfmt,ngkmax,wfir)
  call genvmatk(vmt1,vir1,ngk(:,ik),igkig(:,:,ik),wfmt,ngkmax,wfir,vmat(:,:,ik))
  deallocate(apwalm,evecfv,evecsv,wfmt,wfir)
end do
!$OMP END DO
!$OMP END PARALLEL
call omp_free(nthd)
! broadcast matrix elements to every process
if (np_mpi.gt.1) then
  n=nstsv*nstsv
  do ik=1,nkpt
    lp=mod(ik-1,np_mpi)
    call mpi_bcast(vmat(:,:,ik),n,mpi_double_complex,lp,mpicom,ierror)
  end do
end if
deallocate(vmt1,vir1)
return
end subroutine

