use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::LinkParser::MatchPath',
    AUTHOR              => 'Yung-chung Lin <xern@cpan.org>',
    VERSION_FROM        => 'lib/Lingua/LinkParser/MatchPath.pm',
    ABSTRACT_FROM       => 'lib/Lingua/LinkParser/MatchPath.pm',
    PREREQ_PM => {
	qw(
	   Exporter::Lite 0.01
           Lex 0
	   Lingua::LinkParser 1
	   Parse::Yapp 0
	   Test::More 0
	   ),
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-LinkParser-MatchPath-*' },
);
