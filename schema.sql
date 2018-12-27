
CREATE TABLE test_run (
    id serial PRIMARY KEY,
    imported_at timestamp DEFAULT CURRENT_TIMESTAMP,
    archived_using text,
    generator text,
    generated timestamp,
    rpa boolean,
    dryrun boolean,
    ignored boolean DEFAULT false
);

CREATE TABLE suite (
    id serial PRIMARY KEY,
    name text,
    full_name text NOT NULL,
    repository text NOT NULL
);
CREATE UNIQUE INDEX ON suite(repository, full_name);

CREATE TABLE suite_result (
    suite_id int REFERENCES suite(id) ON DELETE CASCADE NOT NULL,
    test_run_id int REFERENCES test_run(id) ON DELETE CASCADE NOT NULL,
    status text,
    setup_status text,
    execution_status text,
    teardown_status text,
    start_time timestamp,
    elapsed int,

    fingerprint text,
    setup_fingerprint text,
    execution_fingerprint text,
    teardown_fingerprint text,
    PRIMARY KEY (test_run_id, suite_id)
);
CREATE UNIQUE INDEX ON suite_result(start_time, fingerprint);

CREATE TABLE test_case (
    id serial PRIMARY KEY,
    name text NOT NULL,
    full_name text,
    suite_id int REFERENCES suite(id) NOT NULL
);
CREATE UNIQUE INDEX ON test_case(name, suite_id);

CREATE TABLE test_result (
    test_id int REFERENCES test_case(id) ON DELETE CASCADE NOT NULL,
    test_run_id int REFERENCES test_run(id) ON DELETE CASCADE NOT NULL,
    status text,
    setup_status text,
    execution_status text,
    teardown_status text,
    start_time timestamp,
    elapsed int,
    critical boolean,

    fingerprint text,
    setup_fingerprint text,
    execution_fingerprint text,
    teardown_fingerprint text,
    PRIMARY KEY (test_run_id, test_id)
);

CREATE TABLE log_message (
    id serial PRIMARY KEY,
    test_run_id int REFERENCES test_run(id) ON DELETE CASCADE NOT NULL,
    test_id int REFERENCES test_case(id) ON DELETE CASCADE,
    suite_id int REFERENCES suite(id) ON DELETE CASCADE NOT NULL,
    timestamp timestamp NOT NULL,
    log_level text NOT NULL,
    message text
);

CREATE TABLE suite_metadata (
    suite_id int REFERENCES suite(id) ON DELETE CASCADE NOT NULL,
    test_run_id int REFERENCES test_run(id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    value text,
    PRIMARY KEY (test_run_id, suite_id, name)
);

CREATE TABLE test_tag (
    test_id int REFERENCES test_case(id) ON DELETE CASCADE NOT NULL,
    test_run_id int REFERENCES test_run(id) ON DELETE CASCADE NOT NULL,
    tag text  NOT NULL,
    PRIMARY KEY (test_run_id, test_id, tag)
);

CREATE TABLE keyword_tree (
    fingerprint text PRIMARY KEY,
    keyword text,
    library text,
    status text,
    arguments text[]
);

CREATE TABLE tree_hierarchy (
    fingerprint text REFERENCES keyword_tree(fingerprint),
    subtree text REFERENCES keyword_tree(fingerprint),
    call_index text,
    PRIMARY KEY (fingerprint, subtree, call_index)
);

