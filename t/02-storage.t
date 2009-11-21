use strict;
use Test::More;

use lib 't/lib';

use Data::SearchEngine;
use Data::SearchEngine::Query;
use SearchEngineWee;

my @data = (
    {
        id => '1',
        name => 'One Fish',
        description => 'A fish numbered one'
    },
    {
        id => '2',
        name => 'Two Fish',
        description => 'A fish numbered two'
    },
    {
        id => '3',
        name => 'Red Fish',
        description => 'A fish colored red '
    },
    {
        id => '4',
        name => 'Blue Fish',
        description => 'A fish colored blue'
    },
);

my $searcher = SearchEngineWee->new;
foreach my $prod (@data) {
    $searcher->add($prod);
}

{
    my $query = Data::SearchEngine::Query->new(query => 'Fish');
    my $results = $searcher->search($query);
    my $ser = $results->freeze;
    my $results2 = Data::SearchEngine::Results->thaw($ser);
    cmp_ok($query->query, 'eq', 'Fish');
}

done_testing;