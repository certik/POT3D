#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void mpi_init_thread_wrapper() {
    int argc = 0;
    char **argv = NULL;

    int provided;
    int ierr = MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, &provided);
    if (ierr != 0) {
        printf("MPI_Init_thread failed.\n");
        abort();
    }
}

void mpi_finalize_wrapper(int *ierr) {
    *ierr = MPI_Finalize();
}
