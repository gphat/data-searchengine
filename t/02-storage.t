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

my $verifier = SearchEngineWee->new;
foreach my $prod (@data) {
    $verifier->add($prod);
}

{
    my $query = Data::SearchEngine::Query->new(query => 'Fish');
    my $results = $verifier->query($query);
    my $ser = $results->freeze;
    my $results2 = Data::SearchEngine::Results->thaw($ser);
    cmp_ok($results->total_count, '==', $results2->total_count, 'total_count');
}

done_testing;