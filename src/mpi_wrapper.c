#include <mpi.h>
#include <stdlib.h>
#include <stdio.h>

#define MPI_STATUS_SIZE 5

// Needed
void mpi_init_thread_wrapper(int *required, int *provided, int *ierr) {
    int argc = 0;
    char **argv = NULL;

    int thread_support = (*required == 1) ? MPI_THREAD_FUNNELED : *required;
    *ierr = MPI_Init_thread(&argc, &argv, thread_support, provided);
}

// Needed
void mpi_finalize_wrapper(int *ierr) {
    *ierr = MPI_Finalize();
}
