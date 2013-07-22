package MT::Plugin::Editing::OMV::EntrySubStatus;
# EntrySubStatus (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 5;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');
use vars qw( $SCHEMA_VERSION );
$SCHEMA_VERSION = 0.11_000;

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    schema_version => $SCHEMA_VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/YYYY/MMDDhhmm/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Allow you any sub-status on the usual status of entry and webpage. Your sub-states can be defined freely in plugin settings.">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",

    blog_config_template => "$VENDOR/$MYNAME/config.tmpl",
    settings => new MT::PluginSettings ([
        [ 'draft', { Default => undef } ],
        [ 'published', { Default => undef } ],
        [ 'scheduled', { Default => undef } ],
    ]),

    registry => {
        object_types => {
            entry => {
                sub_status => {
                    type =>         'string',
                    size =>          32,
                    label =>        'Sub Status',
                    revisioned =>    1,
                },
            },
        },
        applications => {
            cms => {
                callbacks => {
                    'template_source.edit_entry' => "${FULLNAME}::Callbacks::template_source_edit_entry",
                    'template_param.edit_entry' => "${FULLNAME}::Callbacks::template_param_edit_entry",
                    'cms_pre_save.entry' => "${FULLNAME}::Callbacks::cms_pre_save",
                    'cms_pre_save.page' => "${FULLNAME}::Callbacks::cms_pre_save",
                },
            },
        },
        tags => {
            help_url => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME#tag-%t",
            function => {
                EntrySubStatus => "${FULLNAME}::Tags::entry_sub_status",
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

1;