package Data::SearchEngine::Results;
use Moose;
use MooseX::AttributeHelpers;
use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

has elapsed => (
    is => 'rw',
    isa => 'Num'
);
has items => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef[Data::SearchEngine::Item]',
    default => sub { [] },
    provides => {
        count   => 'count',
        get     => 'get',
        push    => 'add',
    }
);
has query => (
    is => 'rw',
    isa => 'Data::SearchEngine::Query',
    required => 1,
);
has total_count => (
    is => 'rw',
    isa => 'Int',
    default => 0
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Data::SearchEngine::Results - Results of a Data::SearchEngine serach

=head1 SYNOPSIS

The Results object holds the list of items found during a query.  They are
usually sorted by a score.  This object provides some standard attributes
you are likely to use, as well as the ability to serialize via C<freeze> and
C<thaw> thanks to L<MooseX::Storage>.

    use Data::SearchEngine::Item;
    use Data::SearchEngine::Results;
    use Time::HiRes;

    sub query {

        # boring, search specific implementation
        
        my $results = Data::SearchEngine::Results->new(
            query       => $query
            total_count => $total
        );

        my $start = time;
        foreach $product (@sorted_products) {
            my $item = Data::SearchEngine::Item->new(
                id      => $product->id,            # unique product id
                score   => $scores->{$product->id}  # make your own scores
            ));

            $item->set_value('url', 'http://example.com/product/'.$product->id);
            $item->set_value('price', $product->price);

            $results->add($item);
        }
        $results->elapsed(time - $start);

        return $results;
    }

=head1 ATTRIBUTES

=head2 elapsed

The time it took to complete this search.

=head items

The list of L<Data::SearchEngine::Item>s found for the query.

=head query

The L<Data::SearchEngine::Query> that yielded this Results object.

=head1 METHODS

=head add

Appends an Item onto the end of this Results object's item list.

=head get

Gets the item at the specified index.

=head total_count

Returns the total number of items found by the query, not just how many where
returned (which is influenced by count and page).

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.