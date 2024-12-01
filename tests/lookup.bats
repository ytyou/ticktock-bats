setup() {
    load 'common'
    initialize "cleanup_home"
}

teardown() {
    cleanup_home
}

@test "/api/search/lookup tests" {
    run lookup.sh
    echo "output = ${output}"
    assert_success
}
