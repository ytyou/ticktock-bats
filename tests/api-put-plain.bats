setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "/api/put opentsdb telnet style" {
    run api-put-plain.sh
    echo "output = ${output}"
    assert_success
}
