package Data::SearchEngine::Results::Spellcheck;
use Moose::Role;

has spellchecks => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Any]',
    default => sub { {} },
    handles => {
        spellcheck_names=> 'keys',
        set_spellcheck  => 'set',
        get_spellcheck  => 'get'
    }
);

1;

__END__

=head1 NAME

Data::SearchEngine::Results::Spellcheck - spellcheck role for Spellchecking

=head1 SYNOPSIS

    package Data::SeachEngine::Foo;

    with 'Data::SearchEngine::Results::Spellcheck';
    
    sub search {
        # do stuff
        $results->set_spellcheck('popuar', 'popular');
    }

=head1 DESCRIPTION

Provides storage and methods for retrieving spellcheck information.

=head1 ATTRIBUTES

=head2 spellchecks

HashRef of spellcheck suggestions for this query.  The HashRef is keyed by the
word being for which spellcheck suggestions are being provided and the values
are the suggestions.

=head1 METHODS

=head2 spellcheck_names

Returns an array of all the keys of C<spellchecks>.

=head get_spellcheck

Gets the spellcheck with the specified name.  Returns undef if one does not exist.

=head set_spellcheck

Sets the spellcheck with the specified name.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.