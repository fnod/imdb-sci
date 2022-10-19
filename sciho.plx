#!/usr/bin/env perl
use strict;

my $minVotes = 1000;
my $minScore = 7.5;
my %scores = ();

open(my $fh, '<', 'title.ratings.tsv')
    || die "Could not open file: $!";
readline $fh; # skip headers
while (my $line = <$fh>) {
    chomp($line);
    my @sp = split(/\t/, $line);
    if ($sp[2] >= $minVotes && $sp[1] >= $minScore) {
        $scores{$sp[0]} = $sp[1];
    }
}
close $fh;

my @k = keys %scores;
my $n = @k;

open(my $fh, '<', 'title.basics.tsv')
    || die "Could not open file: $!";
readline $fh; # skip headers
while (my $line = <$fh>) {
    chomp($line);
    my @sp = split(/\t/, $line);
    if (index($sp[8], "Sci-Fi") != -1
    && (index($sp[8], "Thriller") != -1 || index($sp[8], "Horror") != -1)
    && $sp[1] eq "movie"
    && exists($scores{$sp[0]})) {
        printf("%s (%s), %s - http://imdb.com/title/%s\n", 
                $sp[2], $sp[5], $scores{$sp[0]}, $sp[0]);
    }
}

