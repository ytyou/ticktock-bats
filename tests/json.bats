setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "input json format" {
    run json.sh
    echo "output = ${output}"
    assert_success
}
