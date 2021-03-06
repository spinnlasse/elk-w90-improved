
! Copyright (C) 2015 Jon Lafuente and Manh Duc Le, 2017-18 Arsenii Gerasimov,
! Yaroslav Kvashnin and Lars Nordstrom.
! This file is distributed under the terms of the GNU General Public License.
! See the file COPYING for license details.

module modw90

!-------------------------------------------------!
!     Wannier90 interface variables               !
!-------------------------------------------------!
integer                      reducek0
! conversion factor from a.u. (Bohr) to Angstrom (needed 4: libwannier.a)
real(8),      parameter   :: au2angstrom = 0.5291772108d0
! total number of atoms to pass to the Wannier90
integer                      wann_natoms
! number of bands to pass to the Wannier90
integer                      wann_nband
! atom symbols to pass to the Wannier90
character(4), allocatable :: wann_atomsymb(:)
! atom Cartesian coordinates in Angstrom
real(8),      allocatable :: wann_atompos(:,:)
! index of bands to pass to the Wannier90
integer,      allocatable :: wann_bands(:)
! list of neighbouring k-points
integer,      allocatable :: wann_nnkp(:,:)
! number of iterations for the minimisation in the Wannier90 iterations
integer                      wann_numiter

! Wannier projections definitions. Uses same syntax as Wannier90 library
! number of projection lines in wannier block
integer                      wann_projlines
! number of lines in wannierExtra block
integer                      wann_inputlines
! list of projections to write to the seedname.win
character(256)               wann_projstr(256)
! arbitrary input for the Wannier90 seedname.win
character(256)               wann_input(256)
! name of all files, produced by interface; default: null
character(256)               wann_seedname
! k-point grid sizes for the Wannier90 calculations
integer                      wann_ngridk(3)
! number of projections per spin
integer                      wann_nproj
! Ang/Bohr units (cart coords)
character(4)                 wann_proj_units
! if proj has weight in this MT
logical,      allocatable :: wann_proj_haswt(:,:)
! use a random s-type gaussian
logical,      allocatable :: wann_proj_isrand(:)
! the radial part on coarse mesh
real(8),      allocatable :: wann_projulr(:,:,:,:)
! the coefficients in Ylm basis
complex(8),   allocatable :: wann_projclm(:,:,:)
! maximum number of nearest neighbours per k-point
integer                   :: num_nnmax = 12

! total number of nearest neighbours for each k-point
integer                      wann_nntot
! list of nearest neighbours for each k-point
integer,      allocatable :: nnlist(:,:)
! vector that brings the nearest neighbour of k-point to its periodic image
integer,      allocatable :: nncell(:,:,:)
! number of bands in first-principles calc. (excluding eg. semi-core states)
integer                   :: wann_nband_total
! number of Wannier functions to calculate
integer                      wann_nwf
! sites coordinates
real(8),      allocatable :: wann_proj_site(:,:)
! l angular momentum number
integer,      allocatable :: wann_proj_l(:)
! m azimuth number
integer,      allocatable :: wann_proj_m(:)
! type of radial function
integer,      allocatable :: wann_proj_radial(:)
! local z-axis
real(8),      allocatable :: wann_proj_zaxis(:,:)
! local x-axis
real(8),      allocatable :: wann_proj_xaxis(:,:)
! Z/a of radial function
real(8),      allocatable :: wann_proj_zona(:)
! k-points independant list of bands to exclude from the calculation
integer,      allocatable :: wann_proj_exclude_bands_lib(:)
! u(+1) or d(-1) in quantdir
integer,      allocatable :: wann_proj_spin(:)
! local spin quantisation dir
real(8),      allocatable :: wann_proj_quantdir(:,:)

end module
