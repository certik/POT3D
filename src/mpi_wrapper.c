#include <mpi.h>

void mpi_init_thread_wrapper() {
    int argc = 0;
    char **argv = NULL;

    int thread_support = MPI_THREAD_FUNNELED;
    int provided;
    MPI_Init_thread(&argc, &argv, thread_support, &provided);
}

void mpi_finalize_wrapper(int *ierr) {
    *ierr = MPI_Finalize();
}
