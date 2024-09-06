setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "timestamp resolution" {
    run resolution.sh
    echo "output = ${output}"
    assert_success
}
