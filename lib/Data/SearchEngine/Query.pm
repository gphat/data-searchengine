package Data::SearchEngine::Query;
use Moose;
use MooseX::Storage;

with 'MooseX::Storage::Deferred';

use Data::SearchEngine::Meta::Attribute::Trait::Digestable;
use Digest::MD5;

has count => (
    traits => [qw(Digestable)],
    is => 'ro',
    isa => 'Int',
    default => 10
);

has filters => (
    traits => [ 'Hash', 'Digestable' ],
    is => 'rw',
    isa => 'HashRef[Str]',
    default => sub { {} },
    handles => {
        filter_names=> 'keys',
        get_filter => 'get',
        set_filter => 'set',
        has_filters => 'count'
    }
);

has order => (
    traits => [qw(Digestable)],
    is => 'ro',
    isa => 'Str',
    predicate => 'has_order'
);

has original_query => (
    traits => [qw(Digestable)],
    is => 'ro',
    isa => 'Str|Undef',
    lazy => 1,
    default => sub { my $self = shift; return $self->query }
);

has page => (
    is => 'ro',
    isa => 'Int',
    default => 1
);

has query => (
    traits => [qw(Digestable)],
    is => 'rw',
    isa => 'Str',
    predicate => 'has_query'
);

sub digest {
    my $self = shift;

    my $digester = Digest::MD5->new;

    my @attributes = $self->meta->get_attribute_list;
    foreach my $aname (@attributes) {
        my $attr = $self->meta->get_attribute($aname);

        next unless $attr->does('Digest::SearchEngine::Meta::Attribute::Trait::Digestable');

        if($attr->has_digest_value) {
            $digester->add(lc($attr->digest_value));
        } else {
            my $reader = $attr->get_read_method;
            my $val = $attr->$reader;
            if(defined($val)) {
                $digester->add(lc($val));
            }
        }

    }
    return $digester->b64digest;
}

sub has_filter_like {
    my ($self, $predicate) = @_;

    return grep { $predicate->() } $self->filter_names;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Data::SearchEngine::Query - Query to pass to an engine.

=head1 SYNOPSIS

The query object has some common attributes one would expect when performing
a search. It has the added benefit of producing a digest that can be used
with L<Data::SearchEngine::Results> ability to serialize to implement caching.

If you add new attributes to a subclass, be sure and add the Digestable
trait to any attributes you want to be included in the digest as document in
L<Data::SearchEngine::Meta::Attribute::Trait::Digestable>.

=head1 ATTRIBUTES

=head2 count

The number of results this query should return.

=head2 filters

A HashRef of filters used with the query.  The key should be the filter name
and the value is the filter's value.  Consult the documentation for your
backend to see how this is used.

=head2 order

The order in which the results should be sorted.

=head2 original_query

The "original" query that the user searched for.  Provided because some
backends may need to modify the C<query> attribute to a more palatable form.
If no value is provided for this attribute then it will assume the same
value as C<query>.

=head2 page

Which page of results to show.

=head2 query

The query string to search for.

=head1 METHODS

=head2 digest

Returns a unique digest identifying this Query.  Useful as a key when
caching.

=head2 filter_names

Return an array of filter names that are present in this query.

=head2 get_filter

Gets the value for the specified filter.

=head2 has_filters

Predicate that returns true if this query has filters.

=head2 has_filter_like

Returns true if any of the filter names match the provided subroutine:

  $query->set_filter('foo', 'bar');
  $query->has_filter_like(sub { /^fo/ })s; # true!

=head2 has_query

Returns true if this Query has a query string.

=head2 set_filter

Sets the value for the specified filter.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
