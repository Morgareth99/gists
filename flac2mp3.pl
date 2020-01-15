#!/usr/local/bin/perl

# Converts flac files en masse to MP3, setting ID3v2 tags pulled from the flac files
# (c) November 7, 2005 Evan D. Hoffman <evandhoffman@gmail.com>
# Licensed under the BSD license, use it as your own risk
#
# http://www.freebsd.org/copyright/freebsd-license.html
# flac: http://flac.sourceforge.net/download.html
# lame: http://lame.sourceforge.net/download/download.html

$flac = "/usr/local/bin/flac";
$metaflac = "/usr/local/bin/metaflac";
$lame = "/usr/local/bin/lame";
$lame_opts = ' -v --vbr-new -V2 -b 160 -B 320 -h --add-id3v2 ';
$quality = "studio";    # to get syntax type 'lame --preset help'

@crap = `/bin/ls`;

# hash - what data to pull from flac into mp3 id3 tags
%attrs = (
        'ta' => 'ARTIST',
        'tt' => 'TITLE',
        'tl' => 'ALBUM',
        'tn' => 'TRACKNUMBER',
        'ty' => 'DATE',
        'tl' => 'ALBUMTITLE',
        'tg' => 'GENRE'
);


foreach $file (@crap) {
        chomp $file;
        next unless $file =~ m/\.flac$/;

        my ($basename) = $file =~ m/(.*)\.flac$/;

        $cmd = "$metaflac \"$file\" ";
        while ( my ($key, $value) = each (%attrs) ) {
                $cmd .= " --show-tag=$value ";
        }
        my @supercrap = `$cmd`;
        #print "$cmd\n";

        foreach $attribute (@supercrap) {
                chomp $attribute;
                my ($key, $val, $junk)  = split (/\=/,$attribute);
                $$key{$file} = $val;
        }

        $flac_cmd = "$flac -d -c \"$file\"";

      #  $lame_cmd = "$lame --preset $quality --add-id3v2 ";
        $lame_cmd = "$lame $lame_opts ";
        while ( my ($key, $value) = each (%attrs) ) {
                $lame_cmd .= " --$key \"".$$value{$file}."\" ";
        }

        $lame_cmd .= " - \"$basename.mp3\"";

        $cmd = "$flac_cmd | $lame_cmd";
        #`$flac_cmd | $lame_cmd`;
        print "$cmd\n";
        `$cmd`;

}

exit;
