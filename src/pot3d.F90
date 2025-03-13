module rp1d_def
      use iso_fortran_env
      implicit none
      type :: rp1d
        real(REAL64), dimension(:), pointer, contiguous :: f
      end type
end module
module sds_def
      use iso_fortran_env
      use rp1d_def
      implicit none
      integer, parameter, private :: mxdim = 3
      type :: sds
        integer :: ndim
        integer, dimension(mxdim) :: dims
        logical :: scale
        logical :: hdf32
        type(rp1d), dimension(mxdim) :: scales
        real(REAL64), dimension(:,:,:), pointer, contiguous :: f
      end type
end module
module rdh5_MOD
      contains
subroutine rdh5 (fname,s,ierr)
      use iso_fortran_env
      use sds_def
      implicit none
      type(sds) :: s
      character(*) :: fname
      integer :: ierr
      integer :: i,j,k,n_members,obj_type
      integer :: file_unit = 10
      integer :: prec
      integer, dimension(:), allocatable :: s_dims_bin, maxpts_bin
      integer, dimension(1) :: s_dims_i_bin
      real(REAL32), dimension(:,:,:), allocatable :: f4
      real(REAL32), dimension(:),     allocatable :: f4dim
      real(REAL64), dimension(:,:,:), allocatable :: f8
      real(REAL64), dimension(:),     allocatable :: f8dim
      character(4), parameter :: cname='RDH5'
      logical :: is_scale
      s%ndim = 0
      s%dims(:) = 1
      open(unit=file_unit, file=trim(fname), form='unformatted', access='stream', status='old', iostat=ierr)
      n_members = 3
      s%ndim = 2
      allocate(s_dims_bin(s%ndim))
      allocate(maxpts_bin(s%ndim))
      s_dims_bin = [181, 451]
      maxpts_bin = [181, 451]
      deallocate(maxpts_bin)
      do j=1,s%ndim
        s%dims(j) = INT(s_dims_bin(j))
      end do
      prec = 32
      s%hdf32=.true.
      allocate (s%f(s%dims(1),s%dims(2),s%dims(3)))
      allocate (f4(s%dims(1),s%dims(2),s%dims(3)))
        read(file_unit, iostat=ierr) f4
        do k=1,s%dims(3)
          do j=1,s%dims(2)
            do i=1,s%dims(1)
              s%f(i,j,k) = REAL(f4(i,j,k),REAL64)
            enddo
          enddo
        enddo
      deallocate (f4)
      deallocate(s_dims_bin)
        s%scale=.true.
        do i=1,n_members-1
          is_scale = .true.
          s_dims_i_bin = s%dims(i)
          allocate (s%scales(i)%f(s_dims_i_bin(1)))
          prec = 32
            allocate (f4dim(s_dims_i_bin(1)))
            read(file_unit) f4dim
            do j=1,s%dims(i)
              s%scales(i)%f(j) = REAL(f4dim(j),REAL64)
            end do
            deallocate (f4dim)
        enddo
        do i=s%ndim+1,3
          allocate (s%scales(i)%f(1))
        enddo
end subroutine
end module rdh5_MOD
module rdhdf_2d_MOD
      contains
subroutine rdhdf_2d (fname,scale,nx,ny,f,x,y,ierr)
      use iso_fortran_env
      use sds_def
      use rdh5_MOD
      implicit none
      character(*) :: fname
      logical :: scale
      integer :: nx,ny,i
      real(REAL64), dimension(:,:), pointer :: f
      real(REAL64), dimension(:), pointer :: x,y
      integer :: ierr
      intent(in) :: fname
      intent(out) :: scale,nx,ny,ierr
      type(sds) :: s
      call rdh5 (fname,s,ierr)
      nx=s%dims(1)
      ny=s%dims(2)
      scale=s%scale
      x=>s%scales(1)%f
      y=>s%scales(2)%f
      allocate (f(nx,ny))
      f(:,:)=s%f(:,:,1)
      deallocate (s%f)
end subroutine
end module rdhdf_2d_MOD
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


program POT3D
      use global_dims
      use global_mesh
      use local_dims
      use local_mesh
      implicit none
      allocate (t_g (ntm1_g))
      allocate (th_g (nt_g))
      allocate (ph_g (np_g))
      allocate (r (nrm))
      allocate (rh (nr))
      call set_flux
end program pot3d
