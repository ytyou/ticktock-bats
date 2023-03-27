setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "new duplicates should overwrite old" {
    run duplicates.sh
    echo "output = ${output}"
    assert_success
}
