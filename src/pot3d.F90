module number_types
    use iso_fortran_env
    implicit none
    integer, parameter :: r_typ=REAL64
end module

program POT3D
    use mpi
    use number_types
    implicit none
    real(r_typ), dimension(:), allocatable :: r_g
    integer :: ierr, tcheck
    real(r_typ) :: r0=1._r_typ
    real(r_typ) :: r1=2.5_r_typ
    integer :: nrm1_g=62
    call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
    allocate (r_g (nrm1_g))
    call genmesh (nrm1_g,r_g)
    call MPI_Finalize(ierr)

    contains

    subroutine genmesh (nc,c)
        implicit none
        integer, intent(in) :: nc
        real(r_typ), intent(in) :: c0,c1
        real(r_typ), dimension(nc), intent(out) :: c
        real(r_typ), dimension(:), allocatable :: dc
        c = 0.
        c(1)=r0
        c(nc)=r1
        allocate (dc(nc))
        dc=cshift(c,-1)
        deallocate (dc)
    end subroutine
end program pot3d
