use Test::More tests => 46;
ok(1);

use strict;
use Data::Dumper;
use ExtUtils::testlib;
use Lingua::LinkParser;
use Lingua::LinkParser::MatchPath;

#$Lingua::LinkParser::MatchPath::DEBUG = 1;

my $parser = new Lingua::LinkParser;
my $o = Lingua::LinkParser::MatchPath->new( parser => $parser );

$o->create_matcher($_) foreach grep{!/^#/} grep{$_} map{chomp; $_} <DATA>;

my $text = (grep{!/^#/} grep{$_} split /\n+/, <<'TEXT')[0];
John activates Mary in a bad way.
TEXT

my $sentence = $parser->create_sentence($text);
foreach (@{$o->matcher}){
  ok($_->template);
  ok($_->match($sentence));
  ok($_->match($text));
}

__END__
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

