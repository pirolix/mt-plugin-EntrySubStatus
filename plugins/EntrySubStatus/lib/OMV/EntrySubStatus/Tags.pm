package OMV::EntrySubStatus::Tags;
# $Id: Tags.pm 326 2012-11-28 09:08:24Z pirolix $

use strict;
use warnings;
use MT;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }

### $mt:EntrySubStatus$
sub entry_sub_status {
    my ($ctx, $args) = @_;

    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $key = ( undef, 'draft', 'published', undef, 'scheduled' )[$e->status]
        or return;

    my $config = &instance->get_config_value ($key, 'blog:'. $e->blog_id) || '';
    foreach (split /[\r\n]/, $config) {
        s/^\s+|\s+$//g;
        length or next;
        m/^;/ and next;
        my $hashed = MT::Util::perl_sha1_digest_base64 ($key. $_);
        if ($e->sub_status eq $hashed) {
            return $args->{hashed}
                ? $hashed
                : $_;
        }
    }
    return '';
}

1;