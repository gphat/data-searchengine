package Data::SearchEngine::Results::Spellcheck::Suggestion;
use Moose;

has 'frequency' => (
    is => 'ro',
    isa => 'Num',
    default => 1
);

has 'original_word' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has 'word' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

1;