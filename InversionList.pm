package Algorithm::InversionList;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(
invlist invlist_from_bitstring bitstring_from_invlist data_from_invlist	
);
our $VERSION = '0.01';

sub invlist_from_bitstring
{
    my $string = shift @_;	# this should be a bitstring
    $string =~ s/(1+)/length($1) . ' ' /ge;
    # note that there are no '0' values left except for the '0' bits
    # themselves
    my $prepend = (substr($string, 0, 1) eq '0'); # we prepend if the first bit was 0
    $string =~ s/(0+)/length($1) . ' ' /ge;
    $string = "0 $string" if $prepend;	# so, we start with 0 '1' bits if prepending
    return split ' ', $string;
}

sub invlist
{
 return invlist_from_bitstring(unpack("b*", shift));
}

sub bitstring_from_invlist
{
 my $out = '';				# start with a blank string
 my $append = 1;			# we're appending '1' bits first
 
 foreach my $i (@_)			# for each inversion list value
 {
  $out .= $append x $i;
  $append++;				# 0 => 1, 1 => 2
  $append %= 2;				# 2 => 0, 1 => 1
 }

 return $out;				# return the data
}

sub data_from_invlist
{
 return pack 'b*', bitstring_from_invlist(@_);
}

1;
__END__

=head1 NAME

Algorithm::InversionList - Perl extension for generating an inversion
list from a bit sequence.

=head1 SYNOPSIS

  use Algorithm::InversionList;
  my $data = "Random data here";
  my @inv = invlist($data);
  print "The inversion list is: @inv\n";

  my $out = data_from_invlist(@inv);
  print "From data [$data] we reconstructed [$out]\n";

=head1 DESCRIPTION

Inversion lists are data structures that store a sequence of bits as
the numeric position of each switch between a run of 0 and 1 bits.
Thus, the data "1111111" is encoded as the number 7 in an inversion
list.

Inversion lists are very efficient when the "run" of bits is longer
than the size of the scalar required to hold that run of bits.
Because of the way that Perl stores scalars and lists and the various
architectures to which Perl has been ported, there is no definitive
rule as to what's the exact proportion of bit runs to bitstring length
required to make inversion lists efficient.  Generally, if you see
long runs of repeated 0 or 1 bits, an inversion list may be
appropriate.

=head2 EXPORT

invlist($DATA): Generate an inversion list from a scalar data string

data_from_invlist(@LIST): Generate the data back from an inversion
list

invlist_from_bitstring($BSTRING): Same as invlist(), but expects a bit
string

bitstring_from_invlist(@LIST): Same as data_from_invlist(), but
returns a bit string

=head1 AUTHOR

Teodor Zlatanov E<lt>tzz@lifelogs.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
