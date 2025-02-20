! Fortran code after applying the pass: insert_deallocate
program pot3d
implicit none
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
    integer(4), intent(in) :: nc
    real(8), dimension(nc), intent(inout) :: c
    real(8), dimension(nc) :: dc
    integer(4) :: v__libasr_index_0_
    v__libasr_index_0_ = int(1, kind=4) - 1
    do while (v__libasr_index_0_ + 1 <= nc + 1 - 1)
        v__libasr_index_0_ = v__libasr_index_0_ + 1
        c(v__libasr_index_0_) = real(0, kind=8)
    end do
    c(nc) = 2.5000000000000000e+00_8
    call f_lcompilers_cshift_real____0_real____2(c, 1, nc, -1, dc, 1, nc)
end subroutine genmesh

subroutine f_lcompilers_cshift_real____0_real____2(array, v__1array, v__2array, shift, result, v__1result, v__2result)
    integer(4), intent(in) :: v__1array
    integer(4), intent(in) :: v__2array
    real(8), dimension(v__1array:(v__1array)+(v__2array)-1), intent(in) :: array
    integer(4) :: i
    integer(4) :: j
    integer(4), intent(in) :: v__1result
    integer(4), intent(in) :: v__2result
    real(8), dimension(v__1result:(v__1result)+(v__2result)-1), intent(out) :: result
    integer(4), intent(in) :: shift
    integer(4) :: shift_val
    shift_val = shift
    if (shift < 0) then
        shift_val = shift_val + v__2array + v__1array - 1
    else
        shift_val = shift_val
    end if
    i = 1
    j = shift_val + 1 - 1
    do while (j + 1 <= v__2array + v__1array - 1)
        j = j + 1
        result(i) = array(j)
        i = i + 1
    end do
    j = int(v__1array, kind=4) - 1
    do while (j + 1 <= shift_val + 1)
        j = j + 1
        result(i) = array(j)
        i = i + 1
    end do
    return
end subroutine f_lcompilers_cshift_real____0_real____2

end program pot3d

