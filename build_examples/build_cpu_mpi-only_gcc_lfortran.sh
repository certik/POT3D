set -ex

FC=lfortran

cd src
${FC} -c pot3d.F90 --no-style-warnings --no-warnings
${FC} pot3d.o -o pot3d
cp pot3d ../bin/
