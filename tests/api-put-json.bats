setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "/api/put opentsdb json style" {
    run api-put-json.sh
    echo "output = ${output}"
    assert_success
}
