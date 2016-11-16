print "Enter the string to be encrypted:";
my $str= <STDIN>;
print "Enter the key to be used for encryption:";
my $key = <STDIN>;

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

; this is comment