package Lingua::LinkParser::MatchPath::Lex;

use strict;
use Exporter::Lite;
use Lex;

our @tokens = (
	       # word class
	       POS => '_[pavding]_',
	       WORD_REGEXP => '(?:/.+?/)[i]?',
	       WORD => '\w+',

	       # label class
	       LABEL_REGEXP => '<\/.+?\/>',
	       LABEL => '<.+?>',

	       POUND_SIGN => '#(?=[<(])',
	       EXCLM_SIGN => '!(?=[<\w\/(])',
	       AT_SIGN => '@(?=[<(])',

	       NEWLINE => '\n',
	       EOR => ';',
	       LPAREN => '[(]',
	       RPAREN => '[)]',
#	       QM => '[?]',
#	       AND => '[&,]',
	       OR => '[|]',
	       PERCENT => '[%]',
	       COMMENT => '^\s*#.+?$',

	       ERROR => '.+',
	   );

sub new {
    my $class = shift;
    my %opt = @_;
    bless {
	lexer => Lex->new(@tokens),
	debug => $opt{debug},
    }, $class;
}

sub _get_tokens {
    my $self = shift;
    my $token;
    my ($name, $content);
    while($token = $self->{lexer}->nextToken){
	($name, $content) = ($token->name(), $token->get);
	$name =~ s/.+:://;
	$content =~ s/\n$// if $name =~ /EOR$/;
	die "Error occurred during tokenizing text: ( $content )" if $name =~ /ERROR/;
	last unless $token->name =~ /(?:NEWLINE|COMMENT)$/;
    }
    if (not $self->{lexer}->eof) {
	[ $name, $content ];
    }
}

# post-processing
sub _pp_tokens {
    my $self = shift;
    my $token = $self->{token};
    my @token;
    for ( my $i = 0; $i<@$token; ){
	# one-step matching
	if(
	   $token->[$i][0] =~ /^(?:POUND|EXCML|AT)_SIGN$/o &&
	   $token->[$i+1][0] =~ /^LABEL/o
	   ){
	    push
		@token,
		$token->[$i],
		[ 'LPAREN' => '(' ],
		$token->[$i+1],
		$token->[$i+2],
		[ 'RPAREN' => ')' ];
		$i+=3;
	}
	# append '@' if there is none before '('
	elsif(
	      $token->[$i][0] eq 'LPAREN' &&
	      $token->[$i-1][0] =~ /^(?:WORD|POS)/
	      ){
	    push 
		@token,
                [ 'AT_SIGN' => '@' ],
                $token->[$i];
	    $i+=1;

	}
	else {
	    push @token, $token->[$i];
	    $i++;
	}
    }
    $self->{token} = \@token;
}

sub load {
    my $self = shift;
    $self->{lexer}->from(shift);
    while( my $t = $self->_get_tokens() ){
	push @{$self->{token}}, $t;
    }
    $self->_pp_tokens;
}


sub lex {
    my $self = shift;
    my $t = shift @{$self->{token}};
    if( $t->[0] ){
	printf ("   - %-15s ==> %s\n", @{$t}[1,0]) if $self->{debug};
	return @$t;
    }
    ('', undef);
}
