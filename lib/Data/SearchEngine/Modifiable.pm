package Data::SearchEngine::Modifiable;
use Moose::Role;

requires qw(add present remove remove_by_id update);

no Moose::Role;
1;

__END__

=head1 NAME

Data::SearchEngine::Modifiable - A role for search engines with an updateable
index.

=head1 SYNOPSIS

This is an add-on role that is used in conjunction with L<Data::SearchEngine>
when wrapping an index that can be updated.  Since some indexes may be read
only, the idea is to keep the required methods in this role separate from the
base one.

=head1 METHODS

=head2 add ($thing)

Adds the specified thing to the index.

=head2 present ($thing)

Returns true if the specified thing is present in the index.

=head2 remove ($thing)

Removes the specified thing from the index.  Consult the documentation
for your specific backend.

=head2 remove_by_id ($id)

Remove a specific thing by id.

=head2 update ($thing)

Updates the specified thing in the index.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

