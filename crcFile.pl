use strict;
use warnings;

die "Usage: crc file\n" unless scalar @ARGV >= 1;

undef $/;                  #to read the entire file into buffer. You can optimize the code to read the file chunk at a time.   

sub CreateCRC();           # sub prototype
sub Reflect($$);           # sub prototype
sub InitCRCTable();        # sub prototype

my $buffer;
my $fsize = -s $ARGV[0];   #get the size of the file
my $polynomial = 0x04c11db7;
my @crctable;              # this will contain 256 elements when it fills up

die "\nError opening file. $!" unless open(H, $ARGV[0]);       # open the file if exists
binmode H;                # open it as a binary mode
$buffer = <H>;            # read file into buffer
close(H);                 # close the file

InitCRCTable();                             # call this first before using CreateCRC(), you only need to call it one time	
printf("\nCRC: %lX\n", CreateCRC());        # crc the buffer and return the result


# Creates CRC and returns it to the caller 

sub CreateCRC()
{

   my $crc = 0xFFFFFFFF;
   my ($p,$n);

      for($p=0; $p < $fsize; $p++)
      {
          
        $n = ord(substr($buffer, $p, 1));           
        $crc = ($crc >> 8) ^ $crctable[($crc & 0xFF) ^ $n];         
        
      }           
      return  ($crc ^ 0xFFFFFFFF);           	
}


# Reflect used by Initialize CRC function
# This function does swap with bits

sub Reflect($$)
{       

	my $value = 0;
	my $reflect = shift(@_);      # can also use $_[0]
	my $ch = shift(@_);           #can also use  $_[1]
	my $i;               
        
	# Swap bit 0 for bit 7
	# bit 1 for bit 6, etc.

	for($i = 1; $i < ($ch + 1); $i++)
	{
		if($reflect & 1)
		{
	            $value |= (1 << ($ch - $i));
	            
	        }
	        
		$reflect >>= 1;
	}

	return $value;
}


# Initialize the crc table


sub InitCRCTable()
{

	# 256 values representing ASCII character codes.        
       my ( $i, $j);
         
        
	for($i = 0; $i <= 0xFF; $i++)
	{
		$crctable[$i] = (Reflect($i, 8) << 24);

		for ($j = 0; $j < 8; $j++)
		{			
			$crctable[$i] = ($crctable[$i] << 1) ^ (($crctable[$i] & (1 << 31)) ? $polynomial : 0);			
		}
	
		$crctable[$i] = Reflect($crctable[$i], 32);
	}
}