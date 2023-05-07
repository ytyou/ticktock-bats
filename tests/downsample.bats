setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "downsample" {
    run downsample.sh
    echo "output = ${output}"
    assert_success
}
