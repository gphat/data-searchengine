package Data::SearchEngine::Results::Faceted;
use Moose::Role;

# ABSTRACT: Facet role for Results

=head1 SYNOPSIS

    package Data::SeachEngine::Foo;

    with 'Data::SearchEngine::Results::Faceted';
    
    sub search {
        # do stuff
        $results->set_facet('foo', 'bar');
    }

=head1 DESCRIPTION

Provides storage and methods for retrieving facet information.

=attr facets

HashRef of facets for this query.  The HashRef is keyed by the name of the
facet and the values are the facet's value.

=method facet_names

Returns an array of all the keys of C<facets>.

=method get_facet

Gets the facet with the specified name.  Returns undef if one does not exist.

=method set_facet

Sets the facet with the specified name.

=cut

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