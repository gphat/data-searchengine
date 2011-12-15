package Data::SearchEngine::Results;
use Moose;
use MooseX::Storage;

# ABSTRACT: Results of a Data::SearchEngine search

with 'MooseX::Storage::Deferred';

=head1 DESCRIPTION

The Results object holds the list of items found during a query.  They are
usually sorted by a score. This object provides some standard attributes you
are likely to use.

=head1 SYNOPSIS

    # An example search implementation

    sub search {
        my ($self, $query) = @_;

        # boring, search specific implementation
        
        my $results = Data::SearchEngine::Results->new(
            query       => $query,
            pager       => Data::SearchEngine::Paginator->new # Data::Paginator subclass
        );

        my @sorted_products; # fill with a search or something
        my $scores; # fill with search scores

        my $start = time;
        foreach my $product (@sorted_products) {
            my $item = Data::SearchEngine::Item->new(
                id      => $product->id,            # unique product id
                score   => $scores->{$product->id}  # make your own scores
            );

            $item->set_value('url', 'http://example.com/product/'.$product->id);
            $item->set_value('price', $product->price);

            $results->add($item);
        }
        $results->elapsed(time - $start);

        return $results;
    }

=begin :prelude

=head1 SERIALIZATION

This module uses L<MooseX::Storage::Deferred> to provide serialization.  You
may serialize it thusly:

  my $json = $results->freeze({ format => 'JSON' });
  # ...
  my $results = Data::SearchEngine::Results->thaw($json, { format => 'JSON' });

=end :prelude

=attr elapsed

The time it took to complete this search.

=cut

has elapsed => (
    is => 'rw',
    isa => 'Num'
);

=attr items

The list of L<Data::SearchEngine::Item>s found for the query.

=method add ($item)

Add an item to this result.

=method get ($n)

Get the nth item.

=cut

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

=attr query

The L<Data::SearchEngine::Query> that yielded this Results object.

=cut

has query => (
    is => 'ro',
    isa => 'Data::SearchEngine::Query',
    required => 1,
);

=attr pager

The L<Data::Page> for this result.

=cut

has pager => (
    is => 'ro',
    isa => 'Data::SearchEngine::Paginator'
);

=attr raw

An attribute that a search backend may fill with the "raw" response it
received.  This is useful for retrieving engine-specific information such
as debugging or tracing information. Type is C<Any>.

=cut

has raw => (
    is => 'ro',
    isa => 'Any'
);

__PACKAGE__->meta->make_immutable;

1;
