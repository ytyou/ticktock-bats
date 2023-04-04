setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "restore from append logs" {
    run append.sh
    echo "output = ${output}"
    assert_success
}
