set -ex

CC=clang
FC=lfortran

cd src
${CC} -Wall -g -I$CONDA_PREFIX/include -c mpi_wrapper.c
${FC} -c --cpp --implicit-interface pot3d.F90
${FC} mpi_wrapper.o pot3d.o -o pot3d -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib
cp pot3d ../bin/
cd ..

set +e

for i in {1..30}; do
    echo "Run $i:"
    ./validate.sh
    if [ $? -ne 0 ]; then
        echo "## Validation failed ##"
        cat testsuite/validation/run/pot3d.err
        exit 1
    fi
    echo "--------------------------------"
done
