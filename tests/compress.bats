setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "test various compression algorithms" {
    run compress.sh
    echo "output = ${output}"
    assert_success
}
