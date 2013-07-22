package OMV::EntrySubStatus::Callbacks;
# $Id: Callbacks.pm 326 2012-11-28 09:08:24Z pirolix $

use strict;
use warnings;
use MT;
use MT::Util;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }



### MT::App::CMS::template_source.edit_entry
sub template_source_edit_entry {
    my ($cb, $app, $tmpl) = @_;
    my ($old, $new);

    ### Append a field for sub_status parameter
    $old = quotemeta (<<'MTMLHEREDOC');
<select name="status" id="status" class="full" onchange="highlightSwitch(this)">
MTMLHEREDOC
    $new = <<'MTMLHEREDOC';
<input type="text" name="sub_status" value="<$mt:var name="sub_status" encode_html="1"$>" style="display:none"/>
MTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;

    ### Inject JavaScript codes into 'highlightSwitch' function to update sub_status field
    $old = quotemeta (<<'MTMLHEREDOC');
function highlightSwitch(selection) {
MTMLHEREDOC
    $new = <<'MTMLHEREDOC';
{
    var opt = selection.options[selection.selectedIndex];
    var sub_status = jQuery(opt).attr('sub-status') || 0;
    jQuery('input[name="sub_status"]').val(sub_status);
}
MTMLHEREDOC
    $$tmpl =~ s/($old)/$1$new/;

    ### Replace <option> tag with <optgroup> for draft
    $old = quotemeta (<<'MTMLHEREDOC');
<option value="1"<mt:if name="status_draft"> selected="selected"</mt:if>><__trans phrase="Unpublished (Draft)"></option>
MTMLHEREDOC
    $new = <<'MTMLHEREDOC';
<mt:if name="sub_status_draft"><optgroup label="<__trans phrase="Unpublished (Draft)">"><mt:loop name="sub_status_draft">
    <option value="1" sub-status="<mt:var name="value">"<mt:if name="selected"> selected="selected"</mt:if>><mt:var name="label" escape="html"></option>
</mt:loop></optgroup><mt:else>
    <option value="1"<mt:if name="status_draft"> selected="selected"</mt:if>><__trans phrase="Unpublished (Draft)"></option>
</mt:if>
MTMLHEREDOC
    $$tmpl =~ s/($old)/$new/;

    ### Replace <option> tag with <optgroup> for publishe
    $old = quotemeta (<<'MTMLHEREDOC');
<option value="2"<mt:if name="status_publish"> selected="selected"</mt:if>><__trans phrase="Published"></option>
MTMLHEREDOC
    $new = <<'MTMLHEREDOC';
<mt:if name="sub_status_published"><optgroup label="<__trans phrase="Published">"><mt:loop name="sub_status_published">
    <option value="2" sub-status="<mt:var name="value">"<mt:if name="selected"> selected="selected"</mt:if>><mt:var name="label" escape="html"></option>
</mt:loop></optgroup><mt:else>
    <option value="2"<mt:if name="status_publish"> selected="selected"</mt:if>><__trans phrase="Published"></option>
</mt:if>
MTMLHEREDOC
    $$tmpl =~ s/($old)/$new/;

    ### Replace <option> tag with <optgroup> for scheduled
    $old = quotemeta (<<'MTMLHEREDOC');
<option value="4"<mt:if name="status_future"> selected="selected"</mt:if>><__trans phrase="Scheduled"></option>
MTMLHEREDOC
    $new = <<'MTMLHEREDOC';
<mt:if name="sub_status_scheduled"><optgroup label="<__trans phrase="Scheduled">"><mt:loop name="sub_status_scheduled">
    <option value="4" sub-status="<mt:var name="value">"<mt:if name="selected"> selected="selected"</mt:if>><mt:var name="label" escape="html"></option>
</mt:loop></optgroup><mt:else>
    <option value="4"<mt:if name="status_future"> selected="selected"</mt:if>><__trans phrase="Scheduled"></option>
</mt:if>
MTMLHEREDOC
    $$tmpl =~ s/($old)/$new/g;
}



### MT::App::CMS::template_param.edit_entry
sub template_param_edit_entry {
    my ($cb, $app, $param) = @_;

    my $type = $app->param('_type')
        or return;
    my $id = $app->param('id')
        or return;
    my $blog_id = $app->param('blog_id')
        or return;

    my $entry = MT->model($type)->load($id)
        or return;
    $param->{sub_status} = $entry->sub_status || '';

    foreach my $key (qw/draft published scheduled/) {
        my $config = &instance->get_config_value ($key, "blog:$blog_id") || '';

        my @states;
        foreach (split /[\r\n]/, $config) {
            s/^\s+|\s+$//g;
            length or next;
            m/^;/ and next;
            my $hashed = MT::Util::perl_sha1_digest_base64 ($key. $_);
            push @states, {
                label => $_,
                value => $hashed,
                selected => ($hashed eq $param->{sub_status}),
            };
        }
        $param->{"sub_status_$key"} = \@states if @states;
    }
}



### cms_pre_save.(entry|page)
sub cms_pre_save {
    my ($cb, $app, $obj) = @_;

    defined (my $sub_status = $app->param('sub_status'))
        or return;
    $obj->sub_status ($sub_status);

    return 1; # success
}

1;