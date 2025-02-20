module mpi_c_bindings
    implicit none

    interface
        subroutine c_mpi_init_thread(required, provided, ierr) bind(C, name="mpi_init_thread_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: required
            integer(c_int), intent(in) :: provided
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_init_thread

        subroutine c_mpi_finalize(ierr) bind(C, name="mpi_finalize_wrapper")
            use iso_c_binding, only : c_int
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_finalize
    end interface
end module mpi_c_bindings

module mpi
    implicit none
    integer, parameter :: MPI_THREAD_FUNNELED = 1

    interface MPI_Init_thread
        module procedure MPI_Init_thread_proc
    end interface MPI_Init_thread

    interface MPI_Finalize
        module procedure MPI_Finalize_proc
    end interface MPI_Finalize

   contains

    subroutine MPI_Init_thread_proc(required, provided, ierr)
        use mpi_c_bindings, only : c_mpi_init_thread
        use iso_c_binding, only: c_int
        integer, intent(in) :: required
        integer, intent(in) :: provided
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_init_thread(required, provided, ierr)
        else
            call c_mpi_init_thread(required, provided, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Init_thread failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Finalize_proc(ierr)
        use mpi_c_bindings, only: c_mpi_finalize
        use iso_c_binding, only: c_int
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_finalize(ierr)
        else
            call c_mpi_finalize(local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Finalize failed with error code: ", local_ierr
            end if
        end if
    end subroutine

end module mpi

program POT3D
    use mpi
    implicit none
    integer, parameter :: r_typ=8
    real(r_typ), dimension(:), allocatable :: r_g
    integer :: ierr, tcheck
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
        real(r_typ), dimension(nc), intent(out) :: c
        real(r_typ), dimension(:), allocatable :: dc
        c = 0.
        c(nc)=r1
        allocate (dc(nc))
        dc=cshift(c,-1)
        deallocate (dc)
    end subroutine
end program pot3d
