#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

void mpi_init_thread_wrapper() {
    int argc = 3;
    char **argv = malloc((argc + 1) * sizeof(char *));
    argv[0] = strdup("my_program");
    argv[1] = strdup("-n");
    argv[2] = strdup("4");
    argv[3] = NULL;

    int provided;
    int ierr = MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, &provided);
    if (ierr != 0) {
        printf("MPI_Init_thread failed.\n");
        abort();
    }
}

void mpi_finalize_wrapper() {
    int ierr = MPI_Finalize();
    if (ierr != 0) {
        printf("MPI_Finalize failed.\n");
        abort();
    }
}
