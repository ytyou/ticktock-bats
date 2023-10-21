setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "rollup tests" {
    run rollup.sh
    echo "output = ${output}"
    assert_success
}
