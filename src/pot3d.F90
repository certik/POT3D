module number_types
      use iso_fortran_env
      implicit none
      integer, parameter :: KIND_REAL_8=REAL64
      integer, parameter :: r_typ=KIND_REAL_8
end module

module global_dims
      implicit none
      integer :: nrm1_g=62
end module

module global_mesh
      use number_types
      implicit none
      real(r_typ), dimension(:), allocatable :: r_g
      real(r_typ), parameter, private :: one=1._r_typ
      real(r_typ) :: r0=1._r_typ
      real(r_typ) :: r1=2.5_r_typ
end module

module mpidefs
      use mpi
      implicit none
end module

module meshdef
      use number_types
      implicit none
      integer, parameter :: nmseg=30
end module

program POT3D
      use mpidefs
      use global_dims
      use global_mesh
      implicit none
      integer :: ierr, tcheck
      call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
      allocate (r_g (nrm1_g))
      call set_global_mesh
      call MPI_Finalize(ierr)
end program pot3d

subroutine set_global_mesh
      use number_types
      use global_dims
      use global_mesh
      use meshdef
      implicit none
      call genmesh (9,nrm1_g,r0,r1,nmseg,r_g)
end subroutine

subroutine genmesh (io,nc,c0,c1,nseg,c)
      use number_types
      implicit none
      integer, intent(in) :: io
      integer, intent(in) :: nc
      real(r_typ), intent(in) :: c0,c1
      integer, intent(in) :: nseg
      real(r_typ), dimension(nc), intent(out) :: c
      integer :: ns
      real(r_typ), parameter :: zero=0._r_typ
      real(r_typ), parameter :: one=1._r_typ
      integer :: i,j,nf,ll
      real(r_typ) :: d,dxi
      real(r_typ), dimension(:), allocatable :: dc,rdc
      do nf=1,nseg-1
      end do
      ns=nf-1

      dxi=one/(nc-one)
      c(1)=c0
      c(nc)=c1

      allocate (dc(nc))
      allocate (rdc(nc))

      dc=c-cshift(c,-1)
      rdc=dc/cshift(dc,-1)

      deallocate (dc)
      deallocate (rdc)
end subroutine
