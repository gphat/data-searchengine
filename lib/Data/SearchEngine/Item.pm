package Data::SearchEngine::Item;
use Moose;
use MooseX::Storage;

with 'MooseX::Storage::Deferred';

has id => (
    is => 'rw',
    isa => 'Str'
);

has score => (
    is => 'rw',
    isa => 'Num',
    default => 0
);

has values => (
    traits  => [ 'Hash' ],
    is      => 'rw',
    isa     => 'HashRef[Str|ArrayRef[Str]|Undef]',
    default => sub { {} },
    handles => {
        keys        => 'keys',
        get_value   => 'get',
        set_value   => 'set',
    },
);

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Data::SearchEngine::Item - An individual search result.

=head1 SYNOPSIS

  $result->add(Data::SearchEngine::Item->new(
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

=head1 ATTRIBUTES

=head2 id

A unique identifier for this item.

=head2 values

The name value pairs for this item.

=head2 score

The score this item earned.

=head1 METHODS

=head2 keys

Returns the keys from the values HashRef, e.g. a list of the value names for
this item.

=head2 get_value

Returns the value for the specified key for this item.

=head2 set_value

Sets the value for the specified key for this item.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.