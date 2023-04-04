setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "test compaction" {
    run compact.sh
    echo "output = ${output}"
    assert_success
}
