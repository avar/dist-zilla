use strict;
use warnings;
use Test::More 0.88;
use Test::Fatal qw(exception);

use lib 't/lib';

use JSON 2;
use Test::DZil;

{
  my $tzil = Builder->from_config(
    { dist_root => 'corpus/dist/DZT' },
    {
      add_files => {
        'source/dist.ini' => simple_ini(
          [ GatherDir => ],
          [ PodSyntaxTests => ],
          [ MetaJSON  => ],
        ),
      },
    },
  );

  $tzil->build;

  my $json = $tzil->slurp_file('build/META.json');

  my $meta = JSON->new->decode($json);

  is_deeply(
    $meta->{prereqs},
    {
       develop => { requires => { 'Test::Pod' => '1.41' } },
    },
    'PodSyntaxTests develop prereqs'
  );

  like(
    $tzil->slurp_file('build/xt/release/pod-syntax.t'),
    qr/\Quse Test::Pod 1.41/,
    'xt/release/pod-syntax.t content'
  );
}

done_testing;
