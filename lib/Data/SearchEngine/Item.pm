package Data::SearchEngine::Item;
use Moose;
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
    traits  => [ 'Hash' ],
    is      => 'rw',
    isa     => 'HashRef[Str]',
    default => sub { {} },
    handles => {
        keys      => 'keys',
        get_value => 'get',
        set_value => 'set',
    },
);

__PACKAGE__->meta->make_immutable;

1;