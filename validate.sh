set -ex

POT3D_HOME=$PWD
TEST="validation"
MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

cp ${POT3D_HOME}/testsuite/${TEST}/input/* ${POT3D_HOME}/testsuite/${TEST}/run/
cd ${POT3D_HOME}/testsuite/${TEST}/run

echo "Running POT3D with 1 MPI rank..."
${MPIEXEC} -np 1 ${POT3D_HOME}/bin/pot3d 1> pot3d.log 2>pot3d.err
echo "Done!"
