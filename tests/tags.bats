setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "tags" {
    run tags.sh
    echo "output = ${output}"
    assert_success
}
