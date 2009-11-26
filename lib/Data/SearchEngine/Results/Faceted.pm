package Data::SearchEngine::Results::Faceted;
use Moose::Role;

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

1;

__END__

=head1 NAME

Data::SearchEngine::Results::Faceted - Facet role for Results

=head1 SYNOPSIS

    package Data::SeachEngine::Foo;

    with 'Data::SearchEngine::Results::Faceted';
    
    sub search {
        # do stuff
        $results->set_facet('foo', 'bar');
    }

=head1 DESCRIPTION

Provides storage and methods for retrieving facet information.

=head1 ATTRIBUTES

=head2 facets

HashRef of facet for this query.  The HashRef is keyed by the name of the
facet and the values are facet's value.

=head1 METHODS

=head2 facet_names

Returns an array of all the keys of C<facets>.

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