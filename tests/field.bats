setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "special tag _field" {
    run field.sh
    echo "output = ${output}"
    assert_success
}
