#!/usr/bin/perl

use strict;
use warnings;
use HTTP::Tiny;
use MIME::Base64;

push @ARGV, "https://localhost:3000/favicon.ico" unless @ARGV;

print qq~<link href="data:image/x-icon;base64,~, 

encode_base64(HTTP::Tiny->new->get($ARGV[0])->{content},""), 

qq~" rel="icon" type="image/x-icon">~ || die "something went wrong";

## hummm something does not work here...