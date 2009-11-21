package # Hide from CPAN
    SearchEngineWee;
use Moose;
use Data::Page;

with ('Data::SearchEngine', 'Data::SearchEngine::Modifiable');

use Data::SearchEngine::Item;
use Data::SearchEngine::Results;
use Time::HiRes qw(time);

has index => (
    traits => [ 'Hash' ],
    is        => 'rw',
    isa       => 'HashRef[HashRef]',
    default   => sub { {} },
    handles  => {
        delete  => 'delete',
        exists  => 'exists',
        get     => 'get',
        keys    => 'keys',
        set     => 'set',
    },
);

sub add {
    my ($self, $prod) = @_;

    $self->set($prod->{name}, $prod);
}

sub present {
    my ($self, $prod) = @_;

    return $self->exists($prod->{name});
}

sub search {
    my ($self, $query) = @_;

    my $results = Data::SearchEngine::Results->new(
        query => $query,
        pager => Data::Page->new
    );

    $query = lc($query->query);

    my $start = time;
    my %items;
    my @parts = split(/ /, $query);

    foreach my $part (@parts) {
        foreach my $key ($self->keys) {

            my $prod = $self->get($key);

            my $score = 0;
            my $item = undef;
            if($items{$prod->{id}}) {
                $item = $items{$prod->{id}};
                $score = $item->score;
            }

            if(lc($prod->{name}) =~ /$part/) {
                $score++;
            }

            if(lc($prod->{description}) =~ /$part/) {
                $score++;
            }

            next unless $score > 0;

            if(defined($item)) {
                $item->score($score);
            } else {
                my $item = Data::SearchEngine::Item->new(
                    id          => $prod->{id},
                    score       => $score
                );
                $item->set_value('description', $prod->{description});
                $item->set_value('name', $prod->{name});
                $items{$prod->{id}} = $item;
            }
        }
    }

    my @sorted_keys = sort { $items{$b}->score <=> $items{$a}->score } keys %items;

    my @sorted = ();
    foreach my $s (@sorted_keys) {
        push(@sorted, $items{$s});
    }

    $results->pager->total_entries(scalar(@sorted));
    $results->items(\@sorted);
    $results->elapsed(time - $start);

    return $results;
}

sub remove {
    my ($self, $prod) = @_;

    $self->delete($prod->{name});
}

sub update {
    my ($self, $prod) = @_;

    $self->set($prod->{name}, $prod);
}

1;