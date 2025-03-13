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
