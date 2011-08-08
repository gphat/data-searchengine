package Data::SearchEngine::Modifiable;
use Moose::Role;

# ABSTRACT: A role for search engines with an updateable index.

=head1 DESCRIPTION

This is an add-on role that is used in conjunction with L<Data::SearchEngine>
when wrapping an index that can be updated.  Since some indexes may be read
only, the idea is to keep the required methods in this role separate from the
base one.

=method add ($thing)

Adds the specified thing to the index.

=method present ($thing)

Returns true if the specified thing is present in the index.

=method remove ($thing)

Removes the specified thing from the index.  Consult the documentation
for your specific backend.

=method remove_by_id ($id)

Remove a specific thing by id.

=method update ($thing)

Updates the specified thing in the index.

=cut

requires qw(add present remove remove_by_id update);

no Moose::Role;
1;

