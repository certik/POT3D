program POT3D
    interface
        subroutine c_mpi_init_thread() bind(C, name="mpi_init_thread_wrapper")
        end subroutine c_mpi_init_thread

        subroutine c_mpi_finalize() bind(C, name="mpi_finalize_wrapper")
        end subroutine c_mpi_finalize
    end interface

    integer, parameter :: r_typ=8
    real(r_typ), dimension(:), allocatable :: r_g
    integer :: ierr, tcheck
    real(r_typ) :: r1=2.5_r_typ
    integer :: nrm1_g=62
    call c_mpi_init_thread()
    allocate (r_g (nrm1_g))
    call genmesh (nrm1_g,r_g)
    call c_mpi_finalize()

    contains

    subroutine genmesh (nc,c)
        integer, intent(in) :: nc
        real(r_typ), dimension(nc), intent(out) :: c
        real(r_typ), dimension(:), allocatable :: dc
        c = 0.
        c(nc)=r1
        allocate (dc(nc))
        dc=cshift(c,-1)
    end subroutine
end program pot3d
