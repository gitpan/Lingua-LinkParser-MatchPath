####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Lingua::LinkParser::MatchPath::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 6 "etc/Grammar.y"

# yapp -m Lingua::LinkParser::MatchPath::Parser -o lib/Lingua/LinkParser/MatchPath/Parser.pm etc/Grammar.y

use Data::Dumper;
$Data::Dumper::Terse = 1;
$Data::Dumper::Ident = 0;

sub print_stat {
#  print $_[0]
}
sub translate_regexp {
  shift =~ m,/(.+?)/([i])?$,;
  $2 eq 'i' ? qr/$1/i : qr/$1/;
}



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -1,
		GOTOS => {
			'START' => 2,
			'@1-0' => 1
		}
	},
	{#State 1
		ACTIONS => {
			'LPAREN' => 4
		},
		GOTOS => {
			'RULE' => 3
		}
	},
	{#State 2
		ACTIONS => {
			'' => 5
		}
	},
	{#State 3
		ACTIONS => {
			'EOR' => 6
		}
	},
	{#State 4
		DEFAULT => -3,
		GOTOS => {
			'@2-1' => 7
		}
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		DEFAULT => -2
	},
	{#State 7
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 11,
			'PERCENT' => 14,
			'POS' => 16
		},
		GOTOS => {
			'WORD_TOKEN' => 13,
			'PWORD_CONJUNCT' => 12,
			'WORD_ATOM' => 15
		}
	},
	{#State 8
		ACTIONS => {
			'WORD' => 17,
			'WORD_REGEXP' => 18,
			'POS' => 19
		}
	},
	{#State 9
		DEFAULT => -39
	},
	{#State 10
		DEFAULT => -40
	},
	{#State 11
		DEFAULT => -32,
		GOTOS => {
			'@14-1' => 20
		}
	},
	{#State 12
		DEFAULT => -29
	},
	{#State 13
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 27,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 14
		ACTIONS => {
			'LPAREN' => -30
		},
		DEFAULT => -27,
		GOTOS => {
			'@12-1' => 31,
			'@13-1' => 32
		}
	},
	{#State 15
		DEFAULT => -26
	},
	{#State 16
		DEFAULT => -41
	},
	{#State 17
		DEFAULT => -42
	},
	{#State 18
		DEFAULT => -43
	},
	{#State 19
		DEFAULT => -44
	},
	{#State 20
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 34,
			'POS' => 16
		},
		GOTOS => {
			'WORD_CONJUNCT' => 33,
			'WORD_ATOM' => 35
		}
	},
	{#State 21
		DEFAULT => -5,
		GOTOS => {
			'@3-1' => 36
		}
	},
	{#State 22
		DEFAULT => -25
	},
	{#State 23
		DEFAULT => -24
	},
	{#State 24
		DEFAULT => -20,
		GOTOS => {
			'@10-1' => 37
		}
	},
	{#State 25
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -15,
		GOTOS => {
			'LINKS' => 38,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 26
		DEFAULT => -16
	},
	{#State 27
		ACTIONS => {
			'RPAREN' => 39,
			'OR' => 40
		}
	},
	{#State 28
		DEFAULT => -22,
		GOTOS => {
			'@11-1' => 41
		}
	},
	{#State 29
		DEFAULT => -8,
		GOTOS => {
			'@5-1' => 42
		}
	},
	{#State 30
		DEFAULT => -11,
		GOTOS => {
			'@7-1' => 43
		}
	},
	{#State 31
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'POS' => 16
		},
		GOTOS => {
			'WORD_ATOM' => 44
		}
	},
	{#State 32
		ACTIONS => {
			'LPAREN' => 11
		},
		GOTOS => {
			'PWORD_CONJUNCT' => 45
		}
	},
	{#State 33
		ACTIONS => {
			'AND' => 47,
			'RPAREN' => 46,
			'OR' => 48
		}
	},
	{#State 34
		DEFAULT => -37,
		GOTOS => {
			'@15-1' => 49
		}
	},
	{#State 35
		DEFAULT => -36
	},
	{#State 36
		ACTIONS => {
			'LPAREN' => 24
		},
		GOTOS => {
			'PLINKS' => 50
		}
	},
	{#State 37
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 51,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 38
		ACTIONS => {
			'OR' => 40
		},
		DEFAULT => -14
	},
	{#State 39
		DEFAULT => -4
	},
	{#State 40
		DEFAULT => -17,
		GOTOS => {
			'@9-2' => 52
		}
	},
	{#State 41
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 11,
			'PERCENT' => 14,
			'POS' => 16
		},
		GOTOS => {
			'WORD_TOKEN' => 53,
			'PWORD_CONJUNCT' => 12,
			'WORD_ATOM' => 15
		}
	},
	{#State 42
		ACTIONS => {
			'LPAREN' => 24
		},
		GOTOS => {
			'PLINKS' => 54
		}
	},
	{#State 43
		ACTIONS => {
			'LPAREN' => 24
		},
		GOTOS => {
			'PLINKS' => 55
		}
	},
	{#State 44
		DEFAULT => -28
	},
	{#State 45
		DEFAULT => -31
	},
	{#State 46
		DEFAULT => -33
	},
	{#State 47
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 34,
			'POS' => 16
		},
		GOTOS => {
			'WORD_CONJUNCT' => 56,
			'WORD_ATOM' => 35
		}
	},
	{#State 48
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 34,
			'POS' => 16
		},
		GOTOS => {
			'WORD_CONJUNCT' => 57,
			'WORD_ATOM' => 35
		}
	},
	{#State 49
		ACTIONS => {
			'WORD' => 9,
			'EXCLM_SIGN' => 8,
			'WORD_REGEXP' => 10,
			'LPAREN' => 34,
			'POS' => 16
		},
		GOTOS => {
			'WORD_CONJUNCT' => 58,
			'WORD_ATOM' => 35
		}
	},
	{#State 50
		DEFAULT => -6,
		GOTOS => {
			'@4-3' => 59
		}
	},
	{#State 51
		ACTIONS => {
			'RPAREN' => 60,
			'OR' => 40
		}
	},
	{#State 52
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 61,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 53
		DEFAULT => -23
	},
	{#State 54
		DEFAULT => -9,
		GOTOS => {
			'@6-3' => 62
		}
	},
	{#State 55
		DEFAULT => -12,
		GOTOS => {
			'@8-3' => 63
		}
	},
	{#State 56
		ACTIONS => {
			'AND' => 47,
			'OR' => 48
		},
		DEFAULT => -34
	},
	{#State 57
		ACTIONS => {
			'AND' => 47,
			'OR' => 48
		},
		DEFAULT => -35
	},
	{#State 58
		ACTIONS => {
			'AND' => 47,
			'RPAREN' => 64,
			'OR' => 48
		}
	},
	{#State 59
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 65,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 60
		DEFAULT => -21
	},
	{#State 61
		ACTIONS => {
			'OR' => 40
		},
		DEFAULT => -18
	},
	{#State 62
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 66,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 63
		ACTIONS => {
			'EXCLM_SIGN' => 21,
			'LABEL_REGEXP' => 22,
			'LPAREN' => 24,
			'LABEL' => 23,
			'POUND_SIGN' => 29,
			'AT_SIGN' => 30
		},
		DEFAULT => -19,
		GOTOS => {
			'LINKS' => 67,
			'LINK' => 25,
			'PLINKS' => 26,
			'LABEL_TOKEN' => 28
		}
	},
	{#State 64
		DEFAULT => -38
	},
	{#State 65
		ACTIONS => {
			'OR' => 40
		},
		DEFAULT => -7
	},
	{#State 66
		ACTIONS => {
			'OR' => 40
		},
		DEFAULT => -10
	},
	{#State 67
		ACTIONS => {
			'OR' => 40
		},
		DEFAULT => -13
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 '@1-0', 0,
sub
#line 26 "etc/Grammar.y"
{
	  print_stat "Initialize the state machine\n";
	}
	],
	[#Rule 2
		 'START', 3,
sub
#line 31 "etc/Grammar.y"
{
          $_[0]->{_sm}->add_state(final => 1);
          $_[0]->{_sm}->add_arc();
	  print_stat "THE END\n";
	}
	],
	[#Rule 3
		 '@2-1', 0,
sub
#line 40 "etc/Grammar.y"
{
	  $_[0]->{_sm}->add_state();
	  $_[0]->{_sm}->add_arc();
	}
	],
	[#Rule 4
		 'RULE', 5,
sub
#line 46 "etc/Grammar.y"
{
	}
	],
	[#Rule 5
		 '@3-1', 0,
sub
#line 52 "etc/Grammar.y"
{
	  $_[0]->{_sm}->ENTER_EXCLM;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
	],
	[#Rule 6
		 '@4-3', 0,
sub
#line 56 "etc/Grammar.y"
{
          $_[0]->{_sm}->LEAVE_EXCLM;
	  $_[0]->{_sm}->LOAD_INPUT_ACTION;
	  $_[0]->{_sm}->JOIN_STATES;
	  $_[0]->{_sm}->SET_FAILURE;
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(join => 1);
	  $_[0]->{_sm}->CLEAR_FAILURE;
          $_[0]->{_sm}->CLEAR_BRANCH;
          $_[0]->{_sm}->POP_BRANCHTYPE;
	}
	],
	[#Rule 7
		 'LINKS', 5, undef
	],
	[#Rule 8
		 '@5-1', 0,
sub
#line 69 "etc/Grammar.y"
{
	  $_[0]->{_sm}->ENTER_POUND;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
	],
	[#Rule 9
		 '@6-3', 0,
sub
#line 73 "etc/Grammar.y"
{
	  $_[0]->{_sm}->LEAVE_POUND;
	  $_[0]->{_sm}->LOAD_INPUT_ACTION;
	  $_[0]->{_sm}->JOIN_STATES;
	  $_[0]->{_sm}->add_state();
	  $_[0]->{_sm}->add_arc(join => 1);
	  $_[0]->{_sm}->CLEAR_BRANCH;
          $_[0]->{_sm}->POP_BRANCHTYPE;
	}
	],
	[#Rule 10
		 'LINKS', 5, undef
	],
	[#Rule 11
		 '@7-1', 0,
sub
#line 84 "etc/Grammar.y"
{
	  $_[0]->{_sm}->ENTER_AT;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
	],
	[#Rule 12
		 '@8-3', 0,
sub
#line 88 "etc/Grammar.y"
{
	  $_[0]->{_sm}->LEAVE_AT;
	  $_[0]->{_sm}->JOIN_STATES;
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(join => 1);
          $_[0]->{_sm}->CLEAR_BRANCH;
          $_[0]->{_sm}->POP_BRANCHTYPE;
	}
	],
	[#Rule 13
		 'LINKS', 5, undef
	],
	[#Rule 14
		 'LINKS', 2, undef
	],
	[#Rule 15
		 'LINKS', 1, undef
	],
	[#Rule 16
		 'LINKS', 1, undef
	],
	[#Rule 17
		 '@9-2', 0,
sub
#line 105 "etc/Grammar.y"
{
	  $_[0]->{_sm}->SAVE_TOJOIN_STATE;
	  $_[0]->{_sm}->LOAD_PREV_STATE;
	}
	],
	[#Rule 18
		 'LINKS', 4,
sub
#line 109 "etc/Grammar.y"
{
	  $_[0]->{_sm}->SAVE_TOJOIN_STATE;
        }
	],
	[#Rule 19
		 'LINKS', 0, undef
	],
	[#Rule 20
		 '@10-1', 0,
sub
#line 117 "etc/Grammar.y"
{
	  $_[0]->{_sm}->add_state();
	  $_[0]->{_sm}->add_arc();
	  if($_[0]->{_sm}->{_just_seen_EAP}){
	    $_[0]->{_sm}->STORE_INPUT_ACTION;
	    $_[0]->{_sm}->PUSH_PREV_STATE;
	    $_[0]->{_sm}->{_just_seen_EAP} = 0;
	  }
	  $_[0]->{_sm}->CLEAR_BRANCH;
	  $_[0]->{_sm}->CLEAR_INPUT_ACTION;
	}
	],
	[#Rule 21
		 'PLINKS', 4,
sub
#line 129 "etc/Grammar.y"
{
	}
	],
	[#Rule 22
		 '@11-1', 0,
sub
#line 134 "etc/Grammar.y"
{
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(label => $_[1]);
	}
	],
	[#Rule 23
		 'LINK', 3, undef
	],
	[#Rule 24
		 'LABEL_TOKEN', 1,
sub
#line 143 "etc/Grammar.y"
{
          print_stat "got a label $_[1]\n";
	  $_[1] =~ s/<(.+?)>/$1/;
	  [ 'L' => $_[1] ]
	}
	],
	[#Rule 25
		 'LABEL_TOKEN', 1,
sub
#line 149 "etc/Grammar.y"
{
          print_stat "got a label regexp $_[1]\n";
	  $_[1] =~ s/<(.+?)>/$1/;
	  [ 'LR' => translate_regexp($_[1]) ]
	}
	],
	[#Rule 26
		 'WORD_TOKEN', 1,
sub
#line 157 "etc/Grammar.y"
{
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[1]);
	  $_[1];
	}
	],
	[#Rule 27
		 '@12-1', 0,
sub
#line 163 "etc/Grammar.y"
{ $_[0]->{_sm}->ENTER_wordcapture() }
	],
	[#Rule 28
		 'WORD_TOKEN', 3,
sub
#line 164 "etc/Grammar.y"
{
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[3]);
	  $_[0]->{_sm}->LEAVE_wordcapture;
	  $_[3];
	}
	],
	[#Rule 29
		 'WORD_TOKEN', 1, undef
	],
	[#Rule 30
		 '@13-1', 0,
sub
#line 173 "etc/Grammar.y"
{ $_[0]->{_sm}->ENTER_wordcapture() }
	],
	[#Rule 31
		 'WORD_TOKEN', 3, undef
	],
	[#Rule 32
		 '@14-1', 0,
sub
#line 178 "etc/Grammar.y"
{
	  print_stat "PWORD conjunct\n";
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc();
	}
	],
	[#Rule 33
		 'PWORD_CONJUNCT', 4,
sub
#line 184 "etc/Grammar.y"
{
	}
	],
	[#Rule 34
		 'WORD_CONJUNCT', 3, undef
	],
	[#Rule 35
		 'WORD_CONJUNCT', 3, undef
	],
	[#Rule 36
		 'WORD_CONJUNCT', 1,
sub
#line 197 "etc/Grammar.y"
{
	  print_stat Dumper $_[1];
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[1]);
	  $_[1];
	}
	],
	[#Rule 37
		 '@15-1', 0,
sub
#line 204 "etc/Grammar.y"
{
	  print_stat "within word conjunct\n";
	  $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc();
	}
	],
	[#Rule 38
		 'WORD_CONJUNCT', 4,
sub
#line 210 "etc/Grammar.y"
{
	}
	],
	[#Rule 39
		 'WORD_ATOM', 1,
sub
#line 218 "etc/Grammar.y"
{
	  print_stat "got a word $_[1] and add an arc\n";
	  my $w = [
		   'W' => $_[1]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];

	  $w
	}
	],
	[#Rule 40
		 'WORD_ATOM', 1,
sub
#line 229 "etc/Grammar.y"
{
	  print_stat "got a word regexp $_[1] and add an arc\n";
	  my $w = [
		   'WR' => translate_regexp($_[1])
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	],
	[#Rule 41
		 'WORD_ATOM', 1,
sub
#line 239 "etc/Grammar.y"
{
	  print_stat "got a pos tag $_[1] and add an arc\n";
	  $_[1] =~ s/_(.)_/$1/;
	  my $w = [
		   'P' => $_[1]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	],
	[#Rule 42
		 'WORD_ATOM', 2,
sub
#line 250 "etc/Grammar.y"
{
	  print_stat "got a negative word $_[1]$_[2] and add an arc\n";
	  my $w = [
		   'NW' => $_[2]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w;
	}
	],
	[#Rule 43
		 'WORD_ATOM', 2,
sub
#line 260 "etc/Grammar.y"
{
	  print_stat "got a negative word regexp $_[1]$_[2] and add an arc\n";
	  my $w = [
		   'NWR' => translate_regexp($_[2])
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	],
	[#Rule 44
		 'WORD_ATOM', 2,
sub
#line 270 "etc/Grammar.y"
{
	  print_stat "got a negative pos tag $_[1]$_[2] and add an arc\n";
	  $_[2] =~ s/_(.)_/$1/;
	  my $w = [
		   'NP' => $_[2]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w;
	}
	]
],
                                  @_);
    bless($self,$class);
}

#line 284 "etc/Grammar.y"


1;
