setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "/api/write influxDB line protocol" {
    run api-write.sh
    echo "output = ${output}"
    assert_success
}
