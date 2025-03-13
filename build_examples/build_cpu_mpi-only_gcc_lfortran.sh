set -ex

FC=lfortran

cd src
${FC} -c psi_io.f90 --no-style-warnings --no-warnings
${FC} -c --cpp --implicit-interface pot3d.F90 --no-style-warnings --no-warnings
${FC} psi_io.o pot3d.o -o pot3d
cp pot3d ../bin/
