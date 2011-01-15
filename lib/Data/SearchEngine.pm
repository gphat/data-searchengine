package Data::SearchEngine;
use Moose::Role;

our $VERSION = '0.17';

requires qw(search);

no Moose::Role;
1;

__END__

=head1 NAME

Data::SearchEngine - A role for search engine abstraction.

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

=head2 Step 1 - Extend the Query

If you have specific attributes that you need for your query, subclass the
L<Data::SearchEngine::Query> object and add the attributes.  This part is
optional.

=head2 Step 2 - Wrap a search implementation

Next use the L<Data::SearchEngine> role in a class that wraps your search
implementation. You can find an example in L<Data::SearchEngine::Results>.

=head2 Step 3 - Profit!!!

!!!

=head1 DIGESTS

Data::SearchEngine provides a Digestable trait that can be applied to
attributes of C<Query>.  Attributes with this trait will be added to
a base64 MD5 digest to produce a unique key identifying this query.  You can
then serialize the Result using L<MooseX::Storage> and store it under the
digest of the Query for caching.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

