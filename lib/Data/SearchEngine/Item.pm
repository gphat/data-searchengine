package Data::SearchEngine::Item;
use Moose;
use MooseX::AttributeHelpers;
use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

has id => (
    is => 'rw',
    isa => 'Str'
);

has score => (
    is => 'rw',
    isa => 'Num',
    default => 0
);

has values => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef[Str]',
    default   => sub { {} },
    provides  => {
        keys      => 'keys',
        get       => 'get_value',
        set       => 'set_value',
    },
);

__PACKAGE__->meta->make_immutable;

1;