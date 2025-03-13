set -ex

FC=lfortran
FFLAGS="--fast --skip-pass="dead_code_removal""

cd src
${FC} -c $FFLAGS pot3d.F90 --no-style-warnings --no-warnings
${FC} $FFLAGS pot3d.o -o pot3d
cp pot3d ../bin/
