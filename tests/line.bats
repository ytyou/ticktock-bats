setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "influxdb line protocol" {
    run line.sh
    echo "output = ${output}"
    assert_success
}
