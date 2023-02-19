setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "run as daemon" {
    run run-as-daemon.sh
    assert_success
}
