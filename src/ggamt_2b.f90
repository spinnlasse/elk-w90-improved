
! Copyright (C) 2009 T. McQueen and J. K. Dewhurst.
! This file is distributed under the terms of the GNU General Public License.
! See the file COPYING for license details.

!BOP
! !ROUTINE: ggamt_2b
! !INTERFACE:
subroutine ggamt_2b(is,g2rho,gvrho,vx,vc,dxdgr2,dcdgr2)
! !USES:
use modmain
! !DESCRIPTION:
!   Spin-unpolarised version of {\tt ggamt\_sp\_2b}.
!
! !REVISION HISTORY:
!   Created November 2009 (JKD and TMcQ)
!EOP
!BOC
implicit none
! arguments
integer, intent(in) :: is
real(8), intent(in) :: g2rho(npmtmax),gvrho(npmtmax,3)
real(8), intent(inout) :: vx(npmtmax),vc(npmtmax)
real(8), intent(in) :: dxdgr2(npmtmax),dcdgr2(npmtmax)
! local variables
integer nr,nri,np,i
! allocatable arrays
real(8), allocatable :: rfmt1(:),rfmt2(:),grfmt(:,:)
allocate(rfmt1(npmtmax),rfmt2(npmtmax),grfmt(npmtmax,3))
nr=nrmt(is)
nri=nrmti(is)
np=npmt(is)
!------------------!
!     exchange     !
!------------------!
! convert dxdgr2 to spherical harmonics
call rfsht(nr,nri,dxdgr2,rfmt1)
! compute grad dxdgr2
call gradrfmt(nr,nri,rsp(:,is),rfmt1,npmtmax,grfmt)
! (grad dxdgr2).(grad rho) in spherical coordinates
rfmt1(1:np)=0.d0
do i=1,3
  call rbsht(nr,nri,grfmt(:,i),rfmt2)
  rfmt1(1:np)=rfmt1(1:np)+rfmt2(1:np)*gvrho(1:np,i)
end do
vx(1:np)=vx(1:np)-2.d0*(rfmt1(1:np)+dxdgr2(1:np)*g2rho(1:np))
!---------------------!
!     correlation     !
!---------------------!
! convert dcdgr2 to spherical harmonics
call rfsht(nr,nri,dcdgr2,rfmt1)
! compute grad dcdgr2
call gradrfmt(nr,nri,rsp(:,is),rfmt1,npmtmax,grfmt)
! (grad dcdgr2).(grad rho) in spherical coordinates
rfmt1(1:np)=0.d0
do i=1,3
  call rbsht(nr,nri,grfmt(:,i),rfmt2)
  rfmt1(1:np)=rfmt1(1:np)+rfmt2(1:np)*gvrho(1:np,i)
end do
vc(1:np)=vc(1:np)-2.d0*(rfmt1(1:np)+dcdgr2(1:np)*g2rho(1:np))
deallocate(rfmt1,rfmt2,grfmt)
return
end subroutine
!EOC

