package Data::SearchEngine::Results;
use Moose;
use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

has elapsed => (
    is => 'rw',
    isa => 'Num'
);
has facets => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Any]',
    default => sub { {} },
    handles => {
        facet_names=> 'keys',
        get_facet => 'get',
        set_facet => 'set',
    }
);
has items => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef[Data::SearchEngine::Item]',
    default => sub { [] },
    handles => {
        count   => 'count',
        get     => 'get',
        add     => 'push',
    }
);
has query => (
    is => 'ro',
    isa => 'Data::SearchEngine::Query',
    required => 1,
);
has pager => (
    is => 'ro',
    isa => 'Data::SearchEngine::Paginator'
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
            pager       => Data::Page->new(...)
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

=head2 facet_names

Returns an array of all the keys of C<facets>.

=head2 facets

HashRef of facet for this query.  The HashRef is keyed by the name of the
facet and the values are facet's value.

=head2 items

The list of L<Data::SearchEngine::Item>s found for the query.

=head2 pager

The L<Data::Page> for this result.

=head2 query

The L<Data::SearchEngine::Query> that yielded this Results object.

=head1 METHODS

=head add

Appends an Item onto the end of this Results object's item list.

=head get

Gets the item at the specified index.

=head get_facet

Gets the facet with the specified name.  Returns undef if one does not exist.

=head set_facet

Sets the facet with the specified name.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.