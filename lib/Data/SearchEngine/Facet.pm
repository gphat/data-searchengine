package Data::SearchEngine::Facet;
use Moose;
use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

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
    isa     => 'HashRef[Str]',
    default => sub { {} },
    handles => {
        keys      => 'keys',
        get_value => 'get',
        set_value => 'set',
    },
);

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Data::SearchEngine::Facet - An facet of a search result.

=head1 SYNOPSIS

  $result->add_facet(Data::SearchEngine::Facet->new(
    name => 'Items under $10',
    value => 12
  ));

=head1 DESCRIPTION

A facet represents an statistic from a result.  It is often used to count
occurrences of certain conditions in a result and is inspired by Solr's
facted search feature.

=head1 ATTRIBUTES

=head2 name

The name of this facet.

=head2 value

The value of this facet.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.