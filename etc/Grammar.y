%token EOR WORD WORD_REGEXP LABEL LABEL_REGEXP POS
%token POUND_SIGN EXCLM_SIGN AT_SIGN
%token AND OR LPAREN RPAREN PERCENT
%start START

%{
# yapp -m Lingua::LinkParser::MatchPath::Parser -o lib/Lingua/LinkParser/MatchPath/Parser.pm etc/Grammar.y

# Basically, the semantic actions are shit here. Need to do much refactoring.

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

%}

%% 

START:
        {
	  print_stat "Initialize the state machine\n";
	}
        RULE
	EOR
        {
          $_[0]->{_sm}->add_state(final => 1);
          $_[0]->{_sm}->add_arc();
	  print_stat "THE END\n";
	}
	;


RULE:
        LPAREN {
	  $_[0]->{_sm}->add_state();
	  $_[0]->{_sm}->add_arc();
	}
        WORD_TOKEN
	LINKS
	RPAREN {
	}
	;


LINKS:
	EXCLM_SIGN {
	  $_[0]->{_sm}->ENTER_EXCLM;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
        PLINKS {
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
	LINKS
	|
	POUND_SIGN {
	  $_[0]->{_sm}->ENTER_POUND;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
        PLINKS {
	  $_[0]->{_sm}->LEAVE_POUND;
	  $_[0]->{_sm}->LOAD_INPUT_ACTION;
	  $_[0]->{_sm}->JOIN_STATES;
	  $_[0]->{_sm}->add_state();
	  $_[0]->{_sm}->add_arc(join => 1);
	  $_[0]->{_sm}->CLEAR_BRANCH;
          $_[0]->{_sm}->POP_BRANCHTYPE;
	}
	LINKS
	|
	AT_SIGN {
	  $_[0]->{_sm}->ENTER_AT;
	  $_[0]->{_sm}->{_just_seen_EAP} = 1;
	}
        PLINKS {
	  $_[0]->{_sm}->LEAVE_AT;
	  $_[0]->{_sm}->JOIN_STATES;
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(join => 1);
          $_[0]->{_sm}->CLEAR_BRANCH;
          $_[0]->{_sm}->POP_BRANCHTYPE;
	}
	LINKS
	|
	LINK LINKS
	|
	LINK
	|
	PLINKS
	|
	LINKS
	OR {
	  $_[0]->{_sm}->SAVE_TOJOIN_STATE;
	  $_[0]->{_sm}->LOAD_PREV_STATE;
	}
        LINKS {
	  $_[0]->{_sm}->SAVE_TOJOIN_STATE;
        }

	|
        ;

PLINKS  :
        LPAREN {
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
        LINKS
	RPAREN {
	}
        ;

LINK:
        LABEL_TOKEN {
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(label => $_[1]);
	}
        WORD_TOKEN
	;


LABEL_TOKEN:
        LABEL {
          print_stat "got a label $_[1]\n";
	  $_[1] =~ s/<(.+?)>/$1/;
	  [ 'L' => $_[1] ]
	}
	|
	LABEL_REGEXP {
          print_stat "got a label regexp $_[1]\n";
	  $_[1] =~ s/<(.+?)>/$1/;
	  [ 'LR' => translate_regexp($_[1]) ]
	}
        ;

WORD_TOKEN:
	WORD_ATOM {
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[1]);
	  $_[1];
	}
	|
	PERCENT { $_[0]->{_sm}->ENTER_wordcapture() }
	WORD_ATOM {
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[3]);
	  $_[0]->{_sm}->LEAVE_wordcapture;
	  $_[3];
	}
	|
        PWORD_CONJUNCT
        |
        PERCENT { $_[0]->{_sm}->ENTER_wordcapture() }
	PWORD_CONJUNCT
	;

PWORD_CONJUNCT:
        LPAREN {
	  print_stat "PWORD conjunct\n";
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc();
	}
        WORD_CONJUNCT
	RPAREN {
	}
        ;

WORD_CONJUNCT:
        WORD_CONJUNCT
	AND
	WORD_CONJUNCT
        |
	WORD_CONJUNCT
	OR
	WORD_CONJUNCT
        |
        WORD_ATOM {
	  print_stat Dumper $_[1];
          $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc(word => $_[1]);
	  $_[1];
	}
	|
	LPAREN {
	  print_stat "within word conjunct\n";
	  $_[0]->{_sm}->add_state();
          $_[0]->{_sm}->add_arc();
	}
	WORD_CONJUNCT
	RPAREN {
	}
        ;




WORD_ATOM:
        WORD {
	  print_stat "got a word $_[1] and add an arc\n";
	  my $w = [
		   'W' => $_[1]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];

	  $w
	}
	|
	WORD_REGEXP {
	  print_stat "got a word regexp $_[1] and add an arc\n";
	  my $w = [
		   'WR' => translate_regexp($_[1])
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	|
	POS {
	  print_stat "got a pos tag $_[1] and add an arc\n";
	  $_[1] =~ s/_(.)_/$1/;
	  my $w = [
		   'P' => $_[1]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	|
        EXCLM_SIGN WORD {
	  print_stat "got a negative word $_[1]$_[2] and add an arc\n";
	  my $w = [
		   'NW' => $_[2]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w;
	}
	|
	EXCLM_SIGN WORD_REGEXP {
	  print_stat "got a negative word regexp $_[1]$_[2] and add an arc\n";
	  my $w = [
		   'NWR' => translate_regexp($_[2])
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w
	}
	|
	EXCLM_SIGN POS {
	  print_stat "got a negative pos tag $_[1]$_[2] and add an arc\n";
	  $_[2] =~ s/_(.)_/$1/;
	  my $w = [
		   'NP' => $_[2]
		   => $_[0]->{_sm}->{_wordcapture}
		   => $_[0]->{_sm}->{_multiwp}
	  ];
	  $w;
	}
	;



%%
