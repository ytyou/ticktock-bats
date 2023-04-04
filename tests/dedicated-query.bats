setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "dedicated listeners to handle query requests" {
    run dedicated-query.sh
    echo "output = ${output}"
    assert_success
}
