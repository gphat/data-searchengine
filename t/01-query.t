use strict;
use Test::More;

use lib 't/lib';

use Data::SearchEngine::Query;

my $query = Data::SearchEngine::Query->new(
    page => 1,
    count => 12,
    query => 'a product'
);

my $query2 = Data::SearchEngine::Query->new(
    page => 1,
    count => 12,
    query => 'a product'
);

cmp_ok($query->digest, 'eq', $query2->digest, 'digests match');

done_testing;
