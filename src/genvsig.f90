
! Copyright (C) 2002-2005 J. K. Dewhurst, S. Sharma and C. Ambrosch-Draxl.
! This file is distributed under the terms of the GNU General Public License.
! See the file COPYING for license details.

!BOP
! !ROUTINE: genvsig
! !INTERFACE:
subroutine genvsig
! !USES:
use modmain
! !DESCRIPTION:
!   Generates the Fourier transform of the Kohn-Sham effective potential in the
!   interstitial region. The potential is first multiplied by the characteristic
!   function which zeros it in the muffin-tins. See routine {\tt gencfun}.
!
! !REVISION HISTORY:
!   Created January 2004 (JKD)
!EOP
!BOC
implicit none
! local variables
integer ig
! allocatable arrays
complex(8), allocatable :: zfft(:)
allocate(zfft(ngtot))
if (trimvg) then
! trim the Fourier components of vsir for |G| > 3*gkmax
  zfft(:)=vsir(:)
  call zfftifc(3,ngridg,-1,zfft)
  do ig=ng3gk+1,ngtot
    zfft(igfft(ig))=0.d0
  end do
! Fourier transform back to real-space
  call zfftifc(3,ngridg,1,zfft)
! multiply trimmed potential by characteristic function in real-space
  zfft(:)=dble(zfft(:))*cfunir(:)
else
! multiply potential by characteristic function in real-space
  zfft(:)=vsir(:)*cfunir(:)
end if
! Fourier transform to G-space
call zfftifc(3,ngridg,-1,zfft)
! store in global array
do ig=1,ngvec
  vsig(ig)=zfft(igfft(ig))
end do
deallocate(zfft)
return
end subroutine
!EOC

