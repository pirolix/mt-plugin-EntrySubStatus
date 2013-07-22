package OMV::EntrySubStatus::L10N::ja;
# $Id$

use strict;
use base 'OMV::EntrySubStatus::L10N';
use vars qw( %Lexicon );

%Lexicon = (
    # *.pl
    'Allow you any sub-status on the usual status of entry and webpage. Your sub-states can be defined freely in plugin settings.'
        => 'ブログ記事やウェブページの通常のステータスにおいて、副ステータスを使えるようにします。副ステータスは、プラグイン設定で自由に定義することができます。',
    # config.tmpl
    "You can describe some additional sub-states with one by one in a line. A line starting with semicolon will be ignored."
        => '一行につき一つ、副ステータスを追加で記述してください。セミコロンで始まる行は無視されます。',
    "Additional states on draft" => '下書きの追加ステータス',
    "Additional states on published" => '公開の追加ステータス',
    "Additional states on scheduled" => '日時指定の追加ステータス',
);

1;