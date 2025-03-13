set -ex

FC=lfortran
FFLAGS="--fast --skip-pass="dead_code_removal""

cd src
${FC} -c $FFLAGS psi_io.f90 --no-style-warnings --no-warnings
${FC} -c $FFLAGS --cpp --implicit-interface pot3d.F90 --no-style-warnings --no-warnings
${FC} $FFLAGS psi_io.o pot3d.o -o pot3d
cp pot3d ../bin/
