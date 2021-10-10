#!perl
 
use strict;
use warnings;
 
use Test2::Bundle::More;
use Test::BDD::Cucumber::StepFile;
 
Given qr/a usable (\S+) class/, sub { eval "use $1;" };
Given qr/a Digest (\S+) object/, sub {
   my $object = Digest->new($1);
   ok( $object, "Object created" );
   S->{'object'} = $object;
};
 
When qr/I've added "(.+)" to the object/, sub {
   S->{'object'}->add( $1 );
};
 
When "I've added the following to the object", sub {
   S->{'object'}->add( C->data );
};
 
Then qr/the (.+) output is "(.+)"/, sub {
   my $method = {base64 => 'b64digest', 'hex' => 'hexdigest' }->{ $1 } ||
       do { fail("Unknown output type $1"); return };
   is( S->{'object'}->$method, $2 );
};
 
# Note: There's no C<done_testing;> at the end of the step file. This is
#       intentional.