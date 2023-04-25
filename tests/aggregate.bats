setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "aggregator tests" {
    run aggregate.sh
    echo "output = ${output}"
    assert_success
}
