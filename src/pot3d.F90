module number_types
      use iso_fortran_env
      implicit none
      integer, parameter :: KIND_REAL_8=REAL64
      integer, parameter :: r_typ=KIND_REAL_8
end module
module constants
      use number_types
      implicit none
      real(r_typ), parameter :: pi=3.1415926535897932_r_typ
end module
module global_dims
      implicit none
      integer :: nr_g=63,nrm1_g=62
      integer :: nt_g=91,ntm1_g=90
      integer :: np_g=225,npm1_g=224
end module
module local_dims
      implicit none
      integer :: nr
      integer :: nt
      integer :: np
      integer :: nrm
      integer :: ntm
      integer :: npm
end module
module global_mesh
      use number_types
      use constants
      implicit none
      real(r_typ), dimension(:), allocatable :: t_g,th_g
      real(r_typ), dimension(:), allocatable :: ph_g
end module
module local_mesh
      use number_types
      implicit none
      real(r_typ), dimension(:), allocatable :: r,rh
      real(r_typ), dimension(:), allocatable :: t,dt
      real(r_typ), dimension(:), allocatable :: p,ph
end module

module vars
      use number_types
      implicit none
      character(256) :: br0file='br_input_tiny_bin.bin'
end module
program POT3D
      implicit none
      call allocate_global_arrays
      call allocate_local_arrays_r
      call set_flux
end program pot3d
subroutine allocate_global_arrays
      use global_dims
      use global_mesh
      implicit none
      allocate (t_g (ntm1_g))
      allocate (th_g (nt_g))
      allocate (ph_g (np_g))
end subroutine
subroutine allocate_local_arrays_r
      use local_dims
      use local_mesh
      implicit none
      allocate (r (nrm))
      allocate (rh (nr))
end subroutine
subroutine set_flux
      use number_types
      use global_dims
      use global_mesh
      use local_dims
      use local_mesh
      use vars
      implicit none
      real(r_typ), dimension(:,:), allocatable :: br0_g
      integer :: j,k,ierr
      allocate (br0_g(nt_g,np_g))
      call readbr (br0file,br0_g,ierr)
      deallocate(br0_g)
end subroutine
subroutine readbr (fname,br0_g,ierr)
      use number_types
      use global_dims
      use global_mesh
      use vars
      use rdhdf_2d_MOD
      implicit none
      character(*) :: fname
      real(r_typ), dimension(nt_g,np_g) :: br0_g
      integer :: ierr
      real(r_typ), dimension(:,:), pointer :: bn
      real(r_typ), dimension(:), pointer :: tn,pn
      integer :: ntn,npn,j,k
      logical :: scale
      ierr=0
      call rdhdf_2d (fname,scale,ntn,npn,bn,tn,pn,ierr)
      call intrp2d (ntn,npn,tn,pn,bn, &
                    nt_g-2,np_g-2,th_g(2:ntm1_g),ph_g(2:npm1_g), &
                    br0_g(2:ntm1_g,2:npm1_g),ierr)
      deallocate (bn)
      deallocate (tn)
      deallocate (pn)
      br0_g(:,1)=br0_g(:,npm1_g)
      br0_g(:,np_g)=br0_g(:,2)
end subroutine
subroutine intrp2d (nxi,nyi,xi,yi,fi,nx,ny,x,y,f,ierr)
      use number_types
      implicit none
      integer :: nxi,nyi
      real(r_typ), dimension(nxi) :: xi
      real(r_typ), dimension(nyi) :: yi
      real(r_typ), dimension(nxi,nyi) :: fi
      integer :: nx,ny
      real(r_typ), dimension(nx) :: x
      real(r_typ), dimension(ny) :: y
      real(r_typ), dimension(nx,ny) :: f
      integer :: ierr
      integer :: i,j,ii,jj
      real(r_typ) :: dum(1)=0.
      real(r_typ) :: xv,yv,ax,ay
      ierr=0
      do j=1,ny
        yv=y(j)
        call interp (yi,nyi,yv,jj,ay)
        do i=1,nx
          xv=x(i)
          call interp (xi,nxi,xv,ii,ax)
          f(i,j)= (1.-ax)*((1.-ay)*fi(ii  ,jj  )+ay*fi(ii  ,jj+1)) &
                 +    ax *((1.-ay)*fi(ii+1,jj  )+ay*fi(ii+1,jj+1))
        enddo
      enddo
      return
end subroutine
subroutine interp (x,n,xv,i,alpha)
      use number_types
      implicit none
      integer :: n
      real(r_typ), dimension(n) :: x
      real(r_typ) :: xv
      integer :: i
      real(r_typ) :: alpha
      do 100 i=1,n-1
          alpha=1.
          go to 200
  100 continue
      write (*,*)
      write (*,*) 'Value requested = ',xv
      write (*,*) 'Min table value = ',x(1)
  200 continue
end subroutine
