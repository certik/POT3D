set -ex

POT3D_HOME=$PWD
TEST="validation"

cp ${POT3D_HOME}/testsuite/${TEST}/input/* ${POT3D_HOME}/testsuite/${TEST}/run/
cd ${POT3D_HOME}/testsuite/${TEST}/run

echo "Running POT3D with 1 MPI rank..."
${POT3D_HOME}/bin/pot3d
echo "Done!"
