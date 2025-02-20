module mpi
    implicit none

    interface MPI_Finalize
        module procedure MPI_Finalize_proc
    end interface MPI_Finalize

    interface
        subroutine c_mpi_init_thread() bind(C, name="mpi_init_thread_wrapper")
        end subroutine c_mpi_init_thread

        subroutine c_mpi_finalize(ierr) bind(C, name="mpi_finalize_wrapper")
            use iso_c_binding, only : c_int
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_finalize
    end interface

   contains

    subroutine MPI_Finalize_proc(ierr)
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
    call c_mpi_init_thread()
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
