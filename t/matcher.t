use Test::More qw(no_plan);
ok(1);

use ExtUtils::testlib;
use strict;
use Data::Dumper;
use Lingua::LinkParser;
use Lingua::LinkParser::MatchPath;

#$Lingua::LinkParser::MatchPath::DEBUG = 1;

my @pattern = grep{!/^#/} grep{$_} split /\n+/, <<'.';
/^J/ </^S/> !/^inhibit/ <Os> /mary/i;
/^J/ </^S/> activates </^O/> /mary/i;
/^J/ </^S/> !inhibit </^O/> /mary/i;
/^J/ <Ss> _v_ <Os> /mary/i
/^J/ <Ss> !_n_ <Os> /mary/i
%/^J/ <Ss> %_v_ <Os> /mary/i
/^J/ <Ss> !inhibit #<MVp> in <Os> /mary/i;
/^J/ <Ss> !inhibit #(<MVp> in <Js> way) <Os> /mary/i;
/^J/ ( <Ss> _v_ ) <Os>  %/.+/
/^J/ ( <Ss> %_v_ <Os> /mary/i ) 
/^J/ <Ss> _v_ #( <Mv> asdf | <MVp> in ( <asdf> asdf | <Js> %_n_)  ) <Os> /mary/i
/^J/ <Ss> _v_ #<MVp> in <Os> /mary/i
/^J/ #( <Sp> _v_ | <AN> _a_ | <Ss> _v_ )
/^J/ !( <Sp> _v_ ) @( <Ss> _v_ <MVp> in ) <Js>  _n_
/^J/ <Ss> !inhibit #<Os> /mary/i <MVp> in <Js> way #<A> /.+/ #<Ds> /.+/
.

use Lingua::LinkParser::MatchPath::Lex;
foreach my $p (@pattern){
  last;
  (
   my $l = Lingua::LinkParser::MatchPath::Lex->new(
						   debug => 1,
						  )
  )->load($p);
  1 while $l->lex;
}


our $parser = new Lingua::LinkParser;
our $text = (grep{!/^#/} grep{$_} split /\n+/, <<'TEXT')[0];
John activates Mary in a bad way.
TEXT

our $sentence = $parser->create_sentence($text);

foreach my $p (@pattern){
    my $m = path_matcher($p);
    my $result = $m->match($parser, $sentence);
    ok($result);
}
