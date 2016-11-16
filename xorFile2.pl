my $str= "hiiee";
my $key = "heyoo";

my $encoded = xor_encode($str,$key);
my $decoded = xor_encode($encoded,$key);
print "$encoded\n$decoded\n";

sub xor_encode {
    my ($str, $key) = @_;
    my $enc_str = '';
    for my $char (split //, $str){
        my $decode = chop $key;
        $enc_str .= chr(ord($char) ^ ord($decode));
        $key = $decode . $key;
    }
   return $enc_str;
}

