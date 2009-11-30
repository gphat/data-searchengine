package Data::SearchEngine::Paginator;
use Moose;

use MooseX::Storage;

with 'MooseX::Storage::Deferred';

extends 'Data::Paginator';

1;