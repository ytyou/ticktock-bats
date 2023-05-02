setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    : # cleanup_home
}

@test "opentsdb version >2.2 filters" {
    run filters.sh
    echo "output = ${output}"
    assert_success
}
