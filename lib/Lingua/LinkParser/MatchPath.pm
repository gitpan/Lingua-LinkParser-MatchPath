package Lingua::LinkParser::MatchPath;


use strict;
use Lingua::LinkParser;
use Lingua::LinkParser::MatchPath::Lex;
use Lingua::LinkParser::MatchPath::Parser;
use Lingua::LinkParser::MatchPath::SM;

our $VERSION = '0.01';
our @ISA = qw(Lingua::LinkParser);

use Exporter::Lite;
our @EXPORT = qw(path_matcher);

# parenthesize rules and append a semicolon
sub _preprocess {
    my $path = shift;
    $path =~ s/[\s\n]*$//;
    $path .= ';' unless $path =~ /;$/;
    if($path !~ /^\(.+\);$/){
	$path =~ s/;$/\);/;
	$path = '('.$path;
    }
#    print "$path$/";
    $path
}

our $DEBUG;
sub path_matcher {
    my $template = shift;
    # processed template
    my $p_template = _preprocess $template;

    (
     my $l = Lingua::LinkParser::MatchPath::Lex->new(
						    debug => $DEBUG,
						    )
     )->load($p_template);
    my $p = new Lingua::LinkParser::MatchPath::Parser;
    $p->{_sm} =
      Lingua::LinkParser::MatchPath::SM->new($p_template);

    my $v = $p->YYParse(
			yylex => sub { $l->lex },
			yyerror => sub {
			    die "Syntax error in [ $template ]\n";
				     },
#			yydebug => 0x1F,
			);
    $p->{_sm};
}


1;
__END__

=pod

=head1 NAME

Lingua::LinkParser::MatchPath - Match paths in linkage diagrams

=head1 SYNOPSIS

    use Lingua::LinkParser::MatchPath;

    $matcher = path_matcher($template); # see below for the tutorial

    our $parser = new Lingua::LinkParser;
    our $sentence = $parser->create_sentence($text);

    if($matcher->match($parser, $sentence)){
       print "COOL!\nHave got ", join( q/ /, $matcher->item), "\n";
    }



=head1 DESCRIPTION

This module can help check if a linkage path exists in a linkage
diagram generated by L<Lingua::LinkParser>, and can help parse English
texts.

=head2 path_matcher($template)

C<path_matcher()> is auto-exported when importing the module and it
creates a state machine according to our template. The template
tutorial is included below.

  $matcher = path_matcher($template);

=head2 match($parser, $sentence)

After matcher gets initiated, we can call C<match()> to see if it can
match any path in linkages of our sentences. The $sentence is a
sentence object created using C<create_sentence()> provided by
Lingua::LinkParser. B<Lingua::LinkParser::MatchPath> is subclass of
Lingua::LinkParser, so methods of Lingua::LinkParser can be called
directly without re-importing it manually.

  $parser = new Lingua::LinkParser;
  $matcher->match($parser, $parser->create_sentence($sentence));

=head2 item()

C<item()> is reserved to retrieve link labels and words along the
path. We can pass arguments specifying which items we would like to
get. The index counts from 0.

  @item = $matcher->item();         # retrieve all of matched items
  @item = $matcher->item(0, 2, 3);  # retrieve 0, 2, 3
  @item = $matcher->item(1, 3..5);  # retrieve 1, 3, 4, 5

Please see below for detail.


=head1 TEMPLATE TUTORIAL

The remaining part of this document will show us how to use the simple
but powerful template language.

=head2 EXAMPLE I

Begin in words. End in words.

Given a sentence : 'Gunther sees Rachel.', and here is a linkage
diagram generated by link parser.

    +-------------Xp------------+
    +---Wd---+---Ss--+--Os--+   |
    |        |       |      |   |
LEFT-WALL Gunther sees.v Rachel .

And now, the goal is to form a template to match the sentence and to
extract the words on the linking path.

If we have a template like this:

 Gunther <Ss>  sees  <Os> Rachel

  ^       ^     ^      ^    ^  
  |       |     |      |    |  
 WORD    LINK  WORD  LINK  WORD

In this example, the path matcher will first locate the position of
B<Gunther>, and check if one of Gunther's linkages contains the label
B<Ss>. If B<Ss> exists, the matcher will continue to see if B<sees> is
further linked by B<Ss>. The process goes on until matcher reaches
full matching or it fails.

Here, this template will match the sentence successfully.

For the definitions of link labels, please go to
L<http://www.link.cs.cmu.edu/link/dict/index.html>


=head2 EXAMPLE II

If we have two sentences:

B<Ross bites Monica.>

and

B<Joey bites Monica too.>

The diagrams are as follows respectively:

    +------------Xp-----------+
    +---Wd--+--Ss-+---Os--+   |
    |       |     |       |   |
LEFT-WALL Ross bites.v Monica .

    +--------------Xp-------------+
    |             +-----MVa----+  |
    +---Wd--+--Ss-+---Os--+    |  |
    |       |     |       |    |  |
LEFT-WALL Joey bites.v Monica too .


There is no need to build two templates: 

 Ross <Ss> bites <Os> Monica

and

 Joey <Ss> bites <Os> Monica

Instead, we can combine them two into one using regexp (regular
expression), and it becomes 

 /Ross|Joey/ <Ss> bites <Os> Monica

Also, we can add a case-insensitive modifier to regexps.

 /ROSS|JOEY/i <Ss> bites <Os> Monica

Our regexp fully complies with perl's regexp.
For regexp tutorial, please see L<perlretut>.

=head2 EXAMPLE III

There is a situation in which we are sure that some words must belong
to a certain class of words in order to satisfy the template, and then
POS (part-of-speech) tag can be used for that.

Given a linkage like this,

    +---------------------------Xp---------------------------+
    |              +----I*d---+------Osn------+              |
    +---Wd---+--Ss-+--N-+     +--K-+  +---Ds--+---Mp--+-Js+  |
    |        |     |    |     |    |  |       |       |   |  |
LEFT-WALL Monica did.v not blow.v up the apartment.n of Ross .

We write a template like this,

 /^Monica/ <I*d> blow <Osn> apartment <Mp> of <Js> Ross

and then we will need to duplicate a house of templates for matching
and miss many linkages with the same structures

Besides using regexps, we can also use POS tags to generalize our
templates in this situation.

 /^Monica/ <I*d> _v_ <Osn> _n_ <Mp> of <Js> Ross

or even

 /.+?/ <I*d> _v_ <Osn> _n_ <Mp> of <Js> /.+?/

Supported tags are B<v> for verb, B<a> for adjective, B<d> for
determiner, B<p> for pronoun, B<n> for noun, etc.

The POS tags attached to words in the above diagram are
auto-identified by LinkParser. This POS-tag feature of pathmatcher is
only valid with identified classes.

=head2 EXAMPLE IV

Regexp can not only be used with words, but with link labels too.

Let's take the above template as an example.

 /.+?/ <I*d> _v_ <Osn> _n_ <Mp> of <Js> /.+?/

If we change the template into this one,

 /.+?/ </^I/> _v_ </^O/> _n_ </^M/> of </^J/> /.+?/

then the link labels with I, O, M, J as their first characters will be
matched.


=head2 EXAMPLE V

Here we introduce our defined B<branching> operator, with which we are
able to write branching templates. This is designed to match multiple
link labels emitted from a word. Otherwise, the pointer will march on
to the next word and continue the matching process.

One common situation is I<negation>. Here we use two simple sentences
with opposite semantics to illustrate this situation:

B<someone is here>

and

B<no one is here>.

And their diagrams:

    +-----------Xp----------+
    +---Wd---+--Ss--+-Pp-+  |
    |        |      |    |  |
LEFT-WALL someone is.v here .

    +-----------Xp-----------+
    +-----Wd----+            |
    |       +-Ds+-Ss-+-Pp-+  |
    |       |   |    |    |  |
LEFT-WALL no.d one is.v here .


They are semantically opposite, but both are fit into a common
structure:

 /one$/ -> <Ss> -> is -> <Pp> -> here

If we merely write template as

 /one$/ <Ss> is <Pp> here

, then both linkages will be matched despite their different
semantics. This is not usually what we want. Usually, we hope to
seperate these two types of semantics, and that is why we introduce
the B<branch> label. With it, this problem is simply solved.

The branch label comes in I<positive> and I<negative> types.

Positive type implies if we have a certain branch emitted from the
current word, then matching is successful; negative one implies
successful matching if we do NOT have a certain branch emitted from
the current word.

Appending a B<#> to the front of a label is indicating the
label is tagged as a positive branch, and B<!> as a negative one.

Then now, we can write down our templates to match the two different
semantics.

For the first case, we don't want to see C<< <Ds> no >> in the diagram

 /one$/ !<Ds> no <Ss> is <Pp> here.
 /one$/ !( <Ds> no ) <Ss> is <Pp> here.

For the second case, we must see a C<< <Ds> no >>.

 /one$/ #<Ds> no <Ss> is <Pp> here
 /one$/ #( <Ds> no ) <Ss> is <Pp> here

Of course, the second template can also be written as

 no <Ds> one <Ss> is <Pp> here

, but it loses the flavor of branching operator and deviates from the
educational intention.

=head2 EXAMPLE VI

Another type of branching, called 'grouping', is introduced here, with
which we can write optional paths for a template.

 /John/ @( <Ss> _v_ | <AN> _a_ )

In this case, the matcher will first try to match <Ss> and _v_ after
successfully matching John. If it fails, it will try <AN> and _a_
later.  @ is used for grouping, with which we can group various
template paths together into one. If parentheses without anything
appended to the front, @ will be appended.

=head2 EXAMPLE VIII

Another operator is designed to capture desired words. In one of the
above examples,

 %/^Monica/ <I*d> _v_ <Osn> _n_ <Mp> of <Js> Ross

if we add % to some of the word templates like

 %/^Monica/ <I*d> %_v_ <Osn> %_n_ <Mp> of <Js> Ross

, then call C<item()>. The method will return 'blow' and 'apartment'
for this example here. This feature is useful for further processing.

=head2 EXAMPLE IX

A finer word capturing can be done using (). In the above example,

 %/^Monica/ <I*d> %_v_ <Osn> %_n_ <Mp> of <Js> Ross

If we parenthesize B<Mon> in Monica as 

 %/^(Mon)ica/ <I*d> %_v_ <Osn> %_n_ <Mp> of <Js> Ross

After a successful matching, we can get B<Mon> calling
$matcher->item(0).


=head1 THE GRAMMAR

The grammar of the template language is listed, and the full grammar with semantic actions are in I<etc/Grammar.y>

    START         -> RULE END_OF_RULE;
    RULE          -> WORD_PATTERN LINKS;
    LINKS         -> LINK | LINK LINKS | PLINKS |
                     LINKS OR LINKS |
                     # PLINKS LINKS | @ PLINKS LINKS | ! PLINKS LINKS |
                     _EPSILON_;
    PLINKS        -> ( LINKS );
    LINK          -> LABEL_PATTERN WORD_PATTERN;
    LABEL_PATTERN -> LABEL | LABEL_REGULAR_EXPRESSION;
    WORD_PATTERN  -> WORD_ATOM | % WORD_ATOM;
    WORD_ATOM     -> WORD | WORD_REGULAR_EXPRESSION | POS_TAG |
                     ! WORD | ! WORD_REGULAR_EXPRESSION | ! POS_TAG;


=head1 TO DO ...

The module cannot handle isolated linkages yet, but patches are always
welcome. I also need to clean up some part of code. Besides, the
interface is so bad for now.

=head1 SEE ALSO

L<Lingua::LinkParser>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Yung-chung Lin (a.k.a. xern) E<lt>xern@cpan.orgE<gt>

This library is free software; Redistribution and/or modification
under the same terms as Perl itself is allowed.

=cut
