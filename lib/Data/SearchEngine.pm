package Data::SearchEngine;
use Moose::Role;

# ABSTRACT: A role for search engine abstraction.

requires qw(search);

=head1 SYNOPSIS

  package Data::SearchEngine::MySearch;

  with 'Data::SearchEngine';

  sub search {
    my ($self, $query) = @_;

    # ... your internal search junk

    my $result = Data::SearchEngine::Results->new(
        query => $query,
        pager => # ... make a Data::Page
    );

    foreach my $hit (@hits) {
        $result->add(Data::SearchEngine::Item->new(
            values => {
                name => $hit->name,
                description => $hit->description
            },
            score => $hit->score
        ));
    }

    return $result;
  }

=head1 DESCRIPTION

There are B<lots> of search engine libraries.  Each has a different interface.
The goal of Data::SearchEngine is to provide a simple, extensive set of
classes and roles that you can use to wrap a search implementation.  The net
result will be an easily swappable backend with a common set of features.

=begin :prelude

=head1 IMPLEMENTATION

=head2 Step 1 - Extend the Query

If you have specific attributes that you need for your query, subclass the
L<Data::SearchEngine::Query> object and add the attributes.  This part is
optional.

=head2 Step 2 - Wrap a search implementation

Next use the L<Data::SearchEngine> role in a class that wraps your search
implementation. You can find an example in L<Data::SearchEngine::Results>.

=head2 Step 3 - Profit!!!

!!!

=end :prelude

=attr defaults

The C<defaults> attribute is a simple HashRef that backends may use to get
default settings from the user.  The implementation of C<search> may then use
these defaults when setting up instances of a search.

=head1 DIGESTS

Data::SearchEngine provides a Digestable trait that can be applied to
attributes of C<Query>.  Attributes with this trait will be added to
a base64 MD5 digest to produce a unique key identifying this query.  You can
then serialize the Result using L<MooseX::Storage> and store it under the
digest of the Query for caching.

=cut

has defaults => (
    traits => [ 'Hash' ],
    is => 'ro',
    isa => 'HashRef',
    handles => {
        set_default => 'set',
        get_default => 'get'
    }
);

=method get_default ($key)

Returns the value from C<defaults> (if any) for the specified key.

=method set_default ($key, $value)

Sets the value in C<defaults>.

=cut

no Moose::Role;
1;
