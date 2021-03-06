#!/usr/bin/env perl -w

use strict;
use Test::More;
eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling" if $@;

add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__DATA__
Plack
middlewares
subrequests
RDBMS
PSGI
TCP
middleware
proxied
PostgreSQL
UI
subdirectory
API
PGXN
CPAN
JSON
