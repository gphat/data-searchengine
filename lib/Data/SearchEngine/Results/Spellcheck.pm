package Data::SearchEngine::Results::Spellcheck;
use Moose::Role;

has spell_collation => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_spell_collation'
);

has spell_frequencies => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Num]',
    default => sub { {} },
    handles => {
        set_spell_frequency  => 'set',
        get_spell_frequency  => 'get'
    }
);

has spell_suggestions => (
    traits => [ 'Hash' ],
    is => 'rw',
    isa => 'HashRef[Data::SearchEngine::Results::Spellcheck::Suggestion]',
    default => sub { {} },
    handles => {
        spell_suggestion_words=> 'keys',
        set_spell_suggestion  => 'set',
        get_spell_suggestion  => 'get'
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
        $results->set_spell_suggestion('popuar', 
          Data::SearchEngine::Results::Spellcheck::Suggestion->new(
            word => 'popular',  # the suggested replacement
            frequency => 12     # optional, how often it occurs in the index
          );
    }

=head1 DESCRIPTION

Provides storage and methods for retrieving spellcheck information.

=head1 ATTRIBUTES

=head2 spell_collation

Intended to hold the 'suggested' spelling result from spellchecking.  A search
for "basebll bat" would likely have a collation of "baseball bat".  It is so
named as it contains a collation of the best results for the various tokens.

=head2 spell_frequencies

Hash containing the original token in as the key and the frequency it occurs
in the index as the value.  This may not be used by all backends.

=head2 spell_sugguestions

HashRef of spellcheck suggestions for this query.  The HashRef is keyed by the
word for which spellcheck suggestions are being provided and the values are
the suggestions.

=head1 METHODS

=head2 get_spell_frequency ($word)

Gets the frequency for the specified word.

=head2 get_spell_suggestion ($word)

Gets the suggestion with the specified name.  Returns undef if one does not exist.

=head2 set_spell_frequency ($word, $frequency)

Sets the frequency for the provided word.

=head2 set_spell_suggestion

Sets the suggestion with the specified name.

=head2 spell_suggestion_words

Returns an array of all the keys of C<suggestions>.

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.