use inc::Module::Install;

name     'Data-SearchEngine';
all_from 'lib/Data/SearchEngine.pm';
author   q{Cory G Watson <gphat@cpan.org>};
license  'perl';

build_requires 'Test::More' => '0.88';

requires 'Digest::SHA1' => '2.12';
requires 'Moose' => '0.89';
requires 'MooseX::AttributeHelpers' => '0.21';
requires 'MooseX::Storage' => '0.21';
requires 'Time::HiRes' => '1.9719';

WriteAll;

