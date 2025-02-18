# build POT3D with LFortran
./build_examples/build_cpu_mpi-only_gcc_lfortran.sh

# here, we run it 30 times and 'cat' the error produced to the
# standard console to see, if the error produced is a segfault
# or some other error

# the error for a segfault, which we are trying to reproduce
# looks like:
# [Gauravs-MacBook-Air:45580] *** Process received signal ***
# [Gauravs-MacBook-Air:45580] Signal: Abort trap: 6 (6)
# [Gauravs-MacBook-Air:45580] Signal code:  (0)
# [Gauravs-MacBook-Air:45580] [ 0] 0   libsystem_platform.dylib            0x00000001855ba584 _sigtramp + 56
# [Gauravs-MacBook-Air:45580] [ 1] 0   libsystem_pthread.dylib             0x0000000185589c20 pthread_kill + 288
# [Gauravs-MacBook-Air:45580] [ 2] 0   libsystem_c.dylib                   0x0000000185496a30 abort + 180
# [Gauravs-MacBook-Air:45580] [ 3] 0   libsystem_malloc.dylib              0x00000001853a6dc4 malloc_vreport + 896
# [Gauravs-MacBook-Air:45580] [ 4] 0   libsystem_malloc.dylib              0x00000001853caea8 malloc_zone_error + 104
# [Gauravs-MacBook-Air:45580] [ 5] 0   libsystem_malloc.dylib              0x00000001853cab48 free_list_checksum_botch + 40
# [Gauravs-MacBook-Air:45580] [ 6] 0   libsystem_malloc.dylib              0x000000018539f524 tiny_free_list_remove_ptr + 452
# [Gauravs-MacBook-Air:45580] [ 7] 0   libsystem_malloc.dylib              0x000000018539ec98 tiny_free_no_lock + 1060
# [Gauravs-MacBook-Air:45580] [ 8] 0   libsystem_malloc.dylib              0x000000018539e6f0 free_tiny + 496
# [Gauravs-MacBook-Air:45580] [ 9] 0   pot3d                               0x0000000102f23a80 genmesh + 1392
# [Gauravs-MacBook-Air:45580] [10] 0   pot3d                               0x0000000102f23ae8 set_global_mesh + 76
# [Gauravs-MacBook-Air:45580] [11] 0   dyld                                0x00000001851ff154 start + 2476
# [Gauravs-MacBook-Air:45580] *** End of error message ***
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
