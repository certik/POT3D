! Fortran code after applying the pass: insert_deallocate
program pot3d
interface
    subroutine c_mpi_finalize() bind(c, name = "mpi_finalize_wrapper")
    end subroutine c_mpi_finalize

    subroutine c_mpi_init_thread() bind(c, name = "mpi_init_thread_wrapper")
    end subroutine c_mpi_init_thread
end interface
integer(4), parameter :: dp = 8
integer(4) :: ierr
integer(4), save :: n = 62
real(8), dimension(:), allocatable :: r_g
integer(4) :: tcheck
call c_mpi_init_thread()
allocate(r_g(n))
call genmesh(n, r_g)
call c_mpi_finalize()
deallocate(r_g) ! Implicit deallocate

contains

subroutine genmesh(nc, c)
    integer(4) :: __libasr_index_0_
    integer(4), intent(in) :: nc
    real(8), dimension(nc), intent(inout) :: c
    real(8), dimension(nc) :: dc
    __libasr_index_0_ = int(1, kind=4) - 1
    do while (__libasr_index_0_ + 1 <= nc + 1 - 1)
        __libasr_index_0_ = __libasr_index_0_ + 1
        c(__libasr_index_0_) = real(0, kind=8)
    end do
    c(nc) = 2.5000000000000000e+00_8
    call _lcompilers_cshift_real____0_real____2(c, 1, nc, -1, dc, 1, nc)
end subroutine genmesh

subroutine _lcompilers_cshift_real____0_real____2(array, __1array, __2array, shift, result, __1result, __2result)
    integer(4), intent(in) :: __1array
    integer(4), intent(in) :: __1result
    integer(4), intent(in) :: __2array
    integer(4), intent(in) :: __2result
    real(8), dimension(__1array:(__1array)+(__2array)-1), intent(in) :: array
    integer(4) :: i
    integer(4) :: j
    real(8), dimension(__1result:(__1result)+(__2result)-1), intent(out) :: result
    integer(4), intent(in) :: shift
    integer(4) :: shift_val
    shift_val = shift
    if (shift < 0) then
        shift_val = shift_val + __2array + __1array - 1
    else
        shift_val = shift_val
    end if
    i = 1
    j = shift_val + 1 - 1
    do while (j + 1 <= __2array + __1array - 1)
        j = j + 1
        result(i) = array(j)
        i = i + 1
    end do
    j = int(__1array, kind=4) - 1
    do while (j + 1 <= shift_val + 1)
        j = j + 1
        result(i) = array(j)
        i = i + 1
    end do
    return
end subroutine _lcompilers_cshift_real____0_real____2

end program pot3d

