program POT3D
    interface
        subroutine c_mpi_init_thread() bind(C, name="mpi_init_thread_wrapper")
        end subroutine c_mpi_init_thread

        subroutine c_mpi_finalize() bind(C, name="mpi_finalize_wrapper")
        end subroutine c_mpi_finalize
    end interface

    integer, parameter :: dp=8
    real(dp), dimension(:), allocatable :: r_g
    integer :: ierr, tcheck
    integer :: N=62
    call c_mpi_init_thread()
    allocate (r_g(N))
    call genmesh (N,r_g)
    call c_mpi_finalize()

    contains

    subroutine genmesh (nc,c)
        integer, intent(in) :: nc
        real(dp), dimension(nc), intent(inout) :: c
        real(dp), dimension(nc) :: dc
        c = 0
        c(nc) = 2.5_dp
        dc=cshift(c,-1)
    end subroutine
end program pot3d
