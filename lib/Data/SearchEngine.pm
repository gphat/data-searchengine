package Data::SearchEngine;
use Moose::Role;

our $VERSION = '0.02';

requires qw(query);

no Moose::Role;
1;

__END__

=head1 NAME

Data::SearchEngine - A role for search engines and serializable results.

=head1 SYNOPSIS

There are B<lots> of search engine libraries.  Each has a different interface.
The goal of Data::SearchEngine is to provide a simple, extensive set of
classes and roles that you can use to wrap a search implementation.  The net
result will be an easily swappable backend with a common set of features, such
as serialize of results for use with a cache.

=head2 Step 1 - Extend the Query

Subclass the L<Data::SearchEngine::Query> object and add attributes that are
needed for your implementation.  Be sure to use the Digestable trait for any
attributes that contribute to the results to guarantee uniqueness.

=head2 Step 2 - Wrap a search implementation

The first step is to use the L<Data::SearchEngine> role in a class that wraps
your search implemenation.  You can find an example in
L<Data::SearchEngine::Results>.

=head2 Step 3 - Profit!!!

Optionally setup a caching implementation using Query's C<digest> method and
the C<freeze>/C<thaw> methods from Results.

=head1 WARNING

This module is under very active development and the API may change.  Consider
this a development release and please send along sugguestions!

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

