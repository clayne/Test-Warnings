# NAME

Test::Warnings - Test for warnings and the lack of them

# VERSION

version 0.004

# SYNOPSIS

    use Test::More;
    use Test::Warnings;

    pass('yay!');
    done_testing;

emits TAP:

    ok 1 - yay!
    ok 2 - no (unexpected) warnings (via done_testing)
    1..2

# DESCRIPTION

If you've ever tried to use [Test::NoWarnings](http://search.cpan.org/perldoc?Test::NoWarnings) to confirm there are no warnings
generated by your tests, combined with the convenience of `done_testing` to
not have to declare a
[test count](http://search.cpan.org/perldoc?Test::More#I love it-when-a-plan-comes-together),
you'll have discovered that these two features do not play well together,
as the test count will be calculated _before_ the warnings test is run,
resulting in a TAP error. (See `examples/test_nowarnings.pl` in this
distribution for a demonstration.)

This module is intended to be used as a drop-in replacement for
[Test::NoWarnings](http://search.cpan.org/perldoc?Test::NoWarnings): it also adds an extra test, but runs this test _before_
`done_testing` calculates the test count, rather than after.  It does this by
hooking into `done_testing` as well as via an `END` block.  You can declare
a plan, or not, and things will still Just Work.

It is actually equivalent to:

    use Test::NoWarnings 1.04 ':early';

as warnings are still printed normally as they occur.  You are safe, and
enthusiastically encouraged, to perform a global search-replace of the above
with `use Test::Warnings;` whether or not your tests have a plan.

# FUNCTIONS

The following functions are available for import (not included by default; you
can also get all of them by importing the tag `:all`):

- `allow_warnings([bool])` - EXPERIMENTAL - MAY BE REMOVED

    When passed a true value, or no value at all, subsequent warnings will not
    result in a test failure; when passed a false value, subsequent warnings will
    result in a test failure.  Initial value is `false`.

    When warnings are allowed, any warnings will instead be emitted via
    [Test::Builder::note](http://search.cpan.org/perldoc?Test::Builder#Output).

- `allowing_warnings` - EXPERIMENTAL - MAY BE REMOVED

    Returns whether we are currently allowing warnings (set by `allow_warnings`
    as described above).

- `had_no_warnings(<optional test name>)`

    Tests whether there have been any warnings so far, not preceded by an
    `allowing_warnings` call.  It is run
    automatically at the end of all tests, but can also be called manually at any
    time, as often as desired.

# OTHER OPTIONS

- `:all` - Imports all functions listed above
- `:no_end_test` - Disables the addition of a `had_no_warnings` test via END (but if you don't want to do this, you probably shouldn't be loading this module at all!)

# CAVEATS

Sometimes new warnings can appear in Perl that should __not__ block
installation -- for example, smartmatch was recently deprecated in
perl 5.17.11, so now any distribution that uses smartmatch and also
tests for warnings cannot be installed under 5.18.0.  You might want to
consider only making warnings fail tests in an author environment -- you can
do this with the [if](http://search.cpan.org/perldoc?if) pragma:

    use if $ENV{AUTHOR_TESTING} || $ENV{RELEASE_TESTING}, 'Test::Warnings';

In future versions of this module, when interfaces are added to test the
content of warnings, there will likely be additional sugar available to
indicate that warnings should be checked only in author tests (or TODO when
not in author testing), but will still provide exported subs.  Comments are
enthusiastically solicited - drop me an email, write up an RT ticket, or come
by `#perl-qa` on irc!

# TO DO (i.e. POSSIBLE FEATURES COMING IN FUTURE RELEASES)

- `allow_warnings(qr/.../)` - allow some warnings and not others
- `warning_is, warning_like etc...` - inclusion of some
[Test::Warn](http://search.cpan.org/perldoc?Test::Warn)\-like functionality for testing the content of warnings, but
closer to a [Test::Fatal](http://search.cpan.org/perldoc?Test::Fatal)\-like syntax
- more sophisticated handling in subtests - if we save some state on the
[Test::Builder](http://search.cpan.org/perldoc?Test::Builder) object itself, we can allow warnings in a subtest and then
the state will revert when the subtest ends, as well as check for warnings at
the end of every subtest via `done_testing`.
- sugar for making failures TODO when testing outside an author
environment

# SUPPORT

Bugs may be submitted through [https://rt.cpan.org/Public/Dist/Display.html?Name=Test-Warnings](https://rt.cpan.org/Public/Dist/Display.html?Name=Test-Warnings).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# SEE ALSO

[Test::NoWarnings](http://search.cpan.org/perldoc?Test::NoWarnings)

[Test::FailWarnings](http://search.cpan.org/perldoc?Test::FailWarnings)

[blogs.perl.org: YANWT (Yet Another No-Warnings Tester)](http://blogs.perl.org/users/ether/2013/03/yanwt-yet-another-no-warnings-tester.html)

[strictures](http://search.cpan.org/perldoc?strictures) - which makes all warnings fatal in tests, hence lessening
the need for special warning testing

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
