use Test;
BEGIN { plan tests => 5 };
use Algorithm::InversionList;
ok(1);

my $data = "Random data here";
my @inv = invlist($data);
ok(scalar @inv);
my $out = data_from_invlist(@inv);
ok($out, $data);

$data = "\0" x 200 . 1 x 200;
$data = $data x 20;
my @inv = invlist($data);
ok(scalar @inv);
$out = data_from_invlist(@inv);
ok($out, $data);
