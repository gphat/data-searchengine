package Data::SearchEngine::Meta::Attribute::Trait::Digestable;
use Moose::Role;

# ABSTRACT: Digest flag & configuration

=head1 SYNOPSIS

If a L<Data::SearchEngine::Query> attribute has this meta-attribute, then it
will be added to the digest that identifies the uniqueness of a Query.

If the attribute is a scalar, you do not need to specify a C<digest_value>.
The scalar value can just be added to the digest.

For example, if your Query subclass allows the choice of a particular
category to search within, you would obviously want queries with different
categories (or lack thereof) to have different digests.

    has 'category' => (
        traits      => [qw(Digestable)],
        is          => 'rw',
        isa         => 'MyApp::Category',
        digest_value=> sub { $self->category->name }
    );

When computing it's digest, your query will now add the value of the category
to the computation, thereby guaranteeing uniqueness!

=attr digest_value

A coderef that will return a string identifying the value of this attribute
for adding to the Query's digst.

=cut

has digest_value => (
    is => 'ro',
    isa => 'CodeRef',
    predicate => 'has_digest_value'
);

no Moose::Role;
1;