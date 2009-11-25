package Data::SearchEngine::Paginator;
use Moose;

use MooseX::Storage;

with Storage(format => 'JSON', io => 'File');

extends 'Data::Paginator';

1;