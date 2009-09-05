use strict;
use Test::More;

use Data::SearchEngine;
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
    my $results = $verifier->query('Fish');
    my $ser = $results->freeze;
    my $results2 = Data::SearchEngine::Results->thaw($ser);
    cmp_ok($results->total_items, '==', $results2->total_items, 'total_items');
}

done_testing;