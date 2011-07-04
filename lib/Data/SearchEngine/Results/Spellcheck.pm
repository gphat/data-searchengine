package Data::SearchEngine::Results::Spellcheck;
use Moose::Role;

# ABSTRACT: spellcheck role for Spellchecking

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

=attr spell_collation

Intended to hold the 'suggested' spelling result from spellchecking.  A search
for "basebll bat" would likely have a collation of "baseball bat".  It is so
named as it contains a collation of the best results for the various tokens.

=cut

has spell_collation => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_spell_collation'
);

=attr spell_frequencies

Hash containing the original token in as the key and the frequency it occurs
in the index as the value.  This may not be used by all backends.

=method get_spell_frequency ($word)

Gets the frequency for the specified word.

=method set_spell_frequency ($word, $frequency)

Sets the frequency for the provided word.

=cut

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

=attr spell_sugguestions

HashRef of spellcheck suggestions for this query.  The HashRef is keyed by the
word for which spellcheck suggestions are being provided and the values are
the suggestions.

=method get_spell_suggestion ($word)

Gets the suggestion with the specified name.  Returns undef if one does not exist.

=method set_spell_suggestion

Sets the suggestion with the specified name.

=method spell_suggestion_words

Returns an array of all the keys of C<suggestions>.

=cut

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

=attr spelled_correctly

Boolean value to signal to the front end if the query was spelled correctly.

=cut

has spelled_correctly => (
    is => 'rw',
    isa => 'Bool',
);

no Moose::Role;
1;