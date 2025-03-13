set -ex

FC=${CONDA_PREFIX}/bin/gfortran
FFLAGS="-fcheck=all -W -Wall"

cd src
${FC} $FFLAGS -c  -cpp pot3d.F90
${FC} $FFLAGS pot3d.o -o pot3d
cp pot3d ../bin/
