package Data::SearchEngine::Query;
use Moose;
use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

use Digest::SHA1;

has count => (
    is => 'ro',
    isa => 'Int',
    default => 10
);

has order => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_order'
);

has page => (
    is => 'ro',
    isa => 'Int',
    default => 1
);

has query => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

sub digest {
    my $self = shift;

    my $digester = Digest::SHA1->new;
    $digester->add($self->count);
    if($self->has_order) {
        $digester->add($self->order);
    }
    $digester->add($self->page);
    $digester->add(lc($self->query));
    return $digester->b64digest;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Data::Verifier::Query - Query to pass to an engine.

=head1 SYNOPSIS

The query object has some common attributes one would expect when performing
a search.  It has the added benefit of producing a digest that can be used
with L<Data::SearchEngine::Results> ability to serialize to implement caching.

Since your query may have different information, it is recommended that you
subclass this class and add whatever attributes you need.  Keep in mind,
however, that you will need to implement your own C<digest> method if you
add any new attributes.

    sub digest {
        my $self = shift;

        my $digester = Digest::SHA1->new;
        $digester->add($self->count);
        if($self->has_order) {
            $digester->add($self->order);
        }
        $digester->add($self->page);
        $digester->add(lc($self->query));
        return $digester->b64digest;
    }

Adding a new attribute or two is as simple as copying the above code and
adding them to the C<$digester> above so that they contribute to the
uniqueness of the query

=head1 ATTRIBUTES

=head2 count

The number of results this query should return.

=head2 order

The order in which the results should be sorted.

=head page

Which page of results to show.

=head query

The query string to search for.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.