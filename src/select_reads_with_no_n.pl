use strict;

my $read_file1 = shift;
my $read_file2 = shift;
my $sn = shift;
my $cn = 0;

my $decompress;
if ($read_file1 =~ /\.gz$/){
  $decompress = "gzip -d -c";
} elsif ($read_file1 =~ /\.bz2$/) {
  $decompress = "bzip2 -d -c";
} else {
  print STDERR "the read file $read_file1 does not seem to be gziped or bziped!!!\n";
  exit 22;
}

open IN1, "$decompress $read_file1 |";
open IN2, "$decompress $read_file2 |";

while ( <IN1> ) {
  my $name1 = $_;
  my $read1 = <IN1>;
  my $name2 = <IN2>;
  my $read2 = <IN2>;
  my $thre1 = <IN1>;
  my $thre2 = <IN2>;
  my $qual1 = <IN1>;
  my $qual2 = <IN2>;

  my $N1 = 0;
  my $N2 = 0;
  while ($read1 =~ /N/g){
    $N1++;
  }
  while ($read2 =~ /N/g){
    $N2++;
  }

  #if ($read1 !~ /N/ and $read2 !~ /N/) { #print
  if ($N1 <= 1 and $N2 <= 1) { #print
      print "$name1";
      print "$read1";
      print "$thre1";
      print "$qual1";
      print STDERR "$name2";
      print STDERR "$read2";
      print STDERR "$thre2";
      print STDERR "$qual2";
      $cn++;
  }
  last if $cn == $sn;
}

close IN1;
close IN2;
