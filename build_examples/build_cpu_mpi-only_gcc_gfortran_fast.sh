set -ex

FC=${CONDA_PREFIX}/bin/gfortran
FFLAGS="-O3 -march=native"

cd src
${FC} $FFLAGS -c psi_io.f90
${FC} $FFLAGS -c  -cpp pot3d.F90
${FC} $FFLAGS psi_io.o pot3d.o -o pot3d
cp pot3d ../bin/
