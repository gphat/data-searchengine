package Data::SearchEngine::Item;
use Moose;
use MooseX::Storage;

# ABSTRACT: An individual search result.

with 'MooseX::Storage::Deferred';

=head1 SYNOPSIS

  my $results = Data::SearchEngine::Results->new;

  $results->add(Data::SearchEngine::Item->new(
    id => 'SKU',
    values => {
        name => 'Foobar',
        description => 'A great foobar!'
    },
    score => 1.0
  ));

=head1 DESCRIPTION

An item represents an individual search result.  It's really just a glorified
HashRef.

=attr id

A unique identifier for this item.

=cut

has id => (
    is => 'rw',
    isa => 'Str'
);

=attr score

The score this item earned.

=cut

has score => (
    is => 'rw',
    isa => 'Num',
    default => 0
);

=attr values

The name value pairs for this item.

=method keys

Returns the keys from the values HashRef, e.g. a list of the value names for
this item.

=method get_value

Returns the value for the specified key for this item.

=method set_value

Sets the value for the specified key for this item.

=cut

has values => (
    traits  => [ 'Hash' ],
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
    handles => {
        keys        => 'keys',
        get_value   => 'get',
        set_value   => 'set',
    },
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;