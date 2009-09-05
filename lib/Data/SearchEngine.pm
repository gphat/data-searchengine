package Data::SearchEngine;
use Moose::Role;

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

The first step is to use the L<Data::SearchEngine> role in a class that wraps
your search implemenation:

    package MySearch::Wrapper;
    use Moose;
    
    with 'Data::SearchEngine';
    
    # implement query

Data::Verifier allows you verify data (such as web forms, which was the
original idea) by leveraging the power of Moose's type constraint system.

    use Data::Verifier;

    my $dv = Data::Verifier->new(
        filters => [ qw(trim) ]
        profile => {
            name => {
                required    => 1,
                type        => 'Str',
                filters     => [ qw(collapse) ]
            }
            age  => {
                type        => 'Int';
            },
            sign => {
                required    => 1,
                type        => 'Str'
            }
        }
    );

    my $results = $dv->verify({
        name => 'Cory', age => 'foobar'
    });

    $results->success; # no

    $results->is_invalid('name'); # no
    $results->is_invalid('age');  # yes

    $results->is_missing('name'); # no
    $results->is_missing('sign'); # yes

    $results->get_value('name'); # Filtered, valid value
    $results->get_value('age');  # undefined, as it's invalid

=head1 MOTIVATION

Data::Verifier firstly intends to leverage Moose's type constraint system,
which is significantly more powerful than anything I could create for the
purposes of this module.  Secondly it aims to keep a fairly simple interface
by leveraging the aforementioned type system to keep options to a minumum.

=head1 WARNING

This module is under very active development and, while the current API
will likely not be changed, features will be added rapidly.

=head1 ATTRIBUTES

=head2 filters

An optional arrayref of filter names through which B<all> values will be
passed.

=head2 profile

The profile is a hashref.  Each value you'd like to verify is a key.  The
values specify all the options to use with the field.  The available options
are:

=over 4

=item B<coerce>

If true then the value will be given an opportunity to coerce via Moose's
type system.

=item B<dependent>

Allows a set of fields to be specifid as dependents of this one.  The argument
for this key is a full-fledged profile as you would give to the profile key:

  my $verifier = Data::Verifier->new(
      profile => {
          password    => {
              dependent => {
                  password2 => {
                      required => 1,
                  }
              }
          }
      }
  );

In the above example C<password> is not required.  If it is provided then
password2 must also be provided.  If any depedents of a field are missing or
invalid then that field is B<invalid>.  In our example if password is provided
and password2 is missing then password will be invalid.

=item B<filters>

An optional list of filters through which this specific value will be run. 
See the documentation for L<Data::Verifier::Filters> to learn more.  This value
may be either a string or an arrayref of strings.  

=item B<max_length>

An optional length which the value may not exceed.

=item B<min_length>

An optional length which the value may not be less.

=item B<post_check>

The C<post_check> key takes a subref and, after all verification has finished,
executes the subref with the results of the verification as it's only argument.
The subref's return value determines if the field to which the post_check
belongs is invalid.  A typical example would be when the value of one field
must be equal to the other, like an email confirmation:

  my $verifier = Data::Verifier->new(
      profile => {
          email    => {
              required => 1,
              dependent => {
                  email2 => {
                      required => 1,
                  }
              },
              post_check => sub {
                  my $r = shift;
                  return $r->get_value('email') eq $r->get_value('email2');
              }
          },
      }
  );

  my $results = $verifier->verify({
      email => 'foo@example.com', email2 => 'foo2@example.com'
  });

  $results->success; # false
  $results->is_valid('email'); # false
  $results->is_valid('email2); # true, as it has no post_check

In the above example, C<success> will return false, because the value of
C<email> does not match the value of C<email2>.  C<is_valid> will return false
for C<email> but true for C<email2>, since nothing specifically invalidated it.
In this example you should rely on the C<email> field, as C<email2> carries no
significance but to confirm C<email>.

=item B<required>

Determines if this field is required for verification.

=item B<type>

The name of the Moose type constraint to use with verifying this field's
value.

=back

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cold Hard Code, LLC

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

