use strict;
use warnings;

my ($stderr, $stderr_copy);

if ("$]" >= '5.008')
{
    open $stderr_copy, '>&', STDERR;
    close STDERR;
    open STDERR, '>', \$stderr
        or die 'something went wrong when redirecting STDERR';
}

END {
    if ("$]" >= '5.008')
    {
        Test::More::note 'suppressed STDERR:', $stderr if $stderr;

        close STDERR;
        open STDERR, '>&', $stderr_copy
            or die 'something went wrong when restoring STDERR';
    }
}
