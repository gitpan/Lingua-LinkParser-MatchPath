package Lingua::LinkParser::MatchPath::SM;
use strict;

use Data::Dumper;

use Lingua::LinkParser::MatchPath::BuildSM;
use Lingua::LinkParser::MatchPath::SMContext;
our @ISA =
    qw(
     Lingua::LinkParser::MatchPath::BuildSM
     Lingua::LinkParser::MatchPath::SMContext
       );

sub print_stat {
#    print @_;
}

sub word_content_and_pos {
    shift() =~ /^(.+?)(?:\[.\])?(?:\.([pavding]))?$/o;
    print_stat "## $1 , $2\n";
    ($1, $2);
}


sub check_wordmatch {
    my ($wordpattern, $content_ref, $pos) = @_;
    my $match = 0;

    if($wordpattern->[0] eq 'W'){
	$match = 1 if $$content_ref eq $wordpattern->[1];
    }
    # word regexp
    elsif($wordpattern->[0] eq 'WR'){
	if( $$content_ref =~ /$wordpattern->[1]/ ){
	    $match = 1;
	    $$content_ref = $1 if $#+ >= 1;
	}
    }
    # pos tag
    elsif($wordpattern->[0] eq 'P'){
	$match = 1 if $pos eq $wordpattern->[1];
    }
    # negative word
    elsif ($wordpattern->[0] eq 'NW'){
	$match = 1 if $$content_ref ne $wordpattern->[1];
    }
    # negative word regexp
    elsif ($wordpattern->[0] eq 'NWR'){
	if( $$content_ref !~ /$wordpattern->[1]/ ){
	    $match = 1;
	}
    }
    # negative pos tag
    elsif ($wordpattern->[0] eq 'NP'){
	$match = 1 if $pos ne $wordpattern->[1];
    }

    return $match;
}

sub check_labelmatch {
    my ($labelpattern, $content) = @_;
    my $match = 0;
    if($labelpattern->[0] eq 'L'){
	return 1 if $content eq $labelpattern->[1];
    }
    elsif($labelpattern->[0] eq 'LR'){
	return 1 if $content =~ /$labelpattern->[1]/;
    }
}


sub get_arcs {
    my $self = shift;
    my $curr_state = shift;
    return ref($self->{_arc}->{$curr_state}) ?
	@{$self->{_arc}->{$curr_state}} : ();
}

sub get_arctype {
    my $self = shift;
    my $arc = shift;
    if($arc->{label}){
	return 'L';
    }
    elsif($arc->{word}){
	return 'W';
    }
    elsif($arc->{branch}){
	return 'EB' if $arc->{branch} eq 'E';
	return 'LB' if $arc->{branch} eq 'L';
    }
    return 'N';
}

sub get_branchtype {
    my $self = shift;
    my $arc = shift;
    $arc->{branch_type};
}

sub match_first_word {
    my $self = shift;
    my $arc = shift;

    my $word_index = 0;

    foreach my $w ($self->{_linkage}->words){
        $word_index++;
	my ($content, $pos) = word_content_and_pos($w->text);

	if (check_wordmatch(
			     $arc->{word}, \$content, $pos
			     )){
	    print_stat "First Word: ", Dumper $w;
	    print_stat "($content, $pos)\n";
	    # word capturing
	    if($arc->{word}->[2]){
		push @{$self->{_item}}, $content;
	    }
	    return $w;
	}
    }
}

sub match_word {
    my $self = shift;
    my $arc = shift;

    if(!$self->{_wordptr}){
	$self->{_wordptr} = $self->match_first_word($arc);
	if($self->{_wordptr}){
	    return (1, $arc->{next_state});
	}
	else {
	    return (0, $arc->{next_state});
	}
    }
    elsif($self->{_wordptr}) {
	my $link = ($self->{_wordptr}->links)[$self->{_label_num}];
	my ($content, $pos) = word_content_and_pos(
						    $link->linkword
						    );

	if($link &&
	   check_wordmatch ($arc->{word}, \$content, $pos)
	   ){
	    $self->{_wordptr} = ($self->{_linkage}->words)[$link->linkposition];
	    print_stat "WORD MATCH";
	    print_stat Dumper $self->{_wordptr};
            # word capturing
            if($arc->{word}->[2]){
                push @{$self->{_item}}, $content;
            }
	    return (1, $arc->{next_state});
	}
	else {
	    return (0, $arc->{next_state});
	}
    }
    else {
	return (0, $arc->{next_state});
    }
}

sub match_label {
    my $self = shift;
    my $arc = shift;

    my @links = $self->{_wordptr}->links;
    my $match;
    foreach my $link_num (0..$#links){
	my $link = $links[$link_num];

	# skip visited labels
	next if $self->{_visited}->{ $link->{index} };

	if(check_labelmatch($arc->{label}, $link->linklabel)){
	    print_stat "LABEL MATCH: ", Dumper $link_num,$/;
	    $self->{_label_num} = $link_num;
	    $self->{_visited}->{ $link->{index} } = 1;
	    $match = 1;
	    last;
	}
    }

    print_stat "VISITED: ", Dumper $self->{_visited},$/;
    if($match){
	(1, $arc->{next_state});
    }
    else {
	(0, $arc->{next_state});
    }
}

sub go {
    my $self = shift;
    my $linkage = shift;

    my $curr_wordptr;
    my $curr_state = 0;
    my $next_state;
    my @arc_stack;
    my @arcs;
    my $cnt;
    my @state_stack;
    my $result;
    my @branchtype_stack;

    $self->{_linkage} = $linkage;

    while(1){
	print_stat Dumper \@state_stack;
	unless($self->{_built_arc_stack}->{$curr_state}){
	    print_stat "State: $curr_state\n";
	    my @arcs = $self->get_arcs($curr_state);
	    if( @arcs > 1 ){
		print_stat scalar(@arcs)." MULTI-BRANCHES\n";
		push @state_stack, $curr_state;
	    }
	    $self->{_arc_stack}->{$curr_state} = \@arcs;
	    $self->{_built_arc_stack}->{$curr_state} = 1;
	}

	my $arc = shift @{$self->{_arc_stack}->{$curr_state}};
	if(!$arc){
	    pop @state_stack;
	    $curr_state = $state_stack[-1];
	    if(!defined $curr_state){
		$self->{_failed} = 1;
		return 0;
	    }
	    next;
	}
	print_stat Dumper $arc;
	my $arctype = $self->get_arctype($arc);
	print_stat Dumper $arctype;

	$result = 1;
	if($arctype eq 'W'){
	    ($result, $next_state) = $self->match_word($arc);
	    print_stat "($result, $next_state)\n";
	}
	elsif($arctype eq 'L'){
	    ($result, $next_state) = $self->match_label($arc);
	}
	elsif($arctype eq 'EB'){
	    my $branchtype = $self->get_branchtype($arc);
	    if($branchtype == 1 || $branchtype == 2){
		push @{$self->{_branch_entrance}}, $curr_state;
		push @{$self->{_wordptr_stack}}, $self->{_wordptr};
		print_stat "PUSH BRANCHTYPE STACK";
		push @branchtype_stack, $branchtype;
	    }
	    $next_state = $arc->{next_state};
	}
	elsif($arctype eq 'LB'){
	    my $branchtype = $self->get_branchtype($arc);
	    if($branchtype == 1 || $branchtype == 2){
		$next_state = pop @{$self->{_branch_entrance}};
		print_stat "POP BRANCHTYPE STACK";
		pop @branchtype_stack;
		print_stat "<<", Dumper($self->{_wordptr_stack}), ">>";
		$self->{_wordptr} = pop @{$self->{_wordptr_stack}};
	    }
	    $next_state = $arc->{next_state};
	}
	elsif($arctype eq 'N') {
	    $next_state = $arc->{next_state};
	}
	else {
	    die;
	}

	if(!$result){
	    if($branchtype_stack[-1] != 2){
		$next_state = $state_stack[-1];
		if(!defined $next_state){
		    $self->{_failed} = 1;
		}
		print_stat "=> MATCH FAILURE, go back to state $next_state\n\n";
	    }
	    else {
		print_stat "SUCCESSFUL MATCHING IN NEGATIVE BRANCH\n";
		print_stat "NEXT_STATE: $next_state\n";
	    }
	}
	$curr_state = $next_state;
	return 1 if $self->accepted($curr_state);
	return 0 if $self->failed;
    }
    1;
}



our $PRINT_DIAGRAM;
our $PRINT_SUCCESSFUL_DIAGRAM;
our $PRINT_DIAGRAM_TO_FILE;
our $PRINT_SUCCESSFUL_DIAGRAM_TO_FILE;

sub match {
    my $self = shift;
    my $Lparser = $_[0];
    my $sentence = $_[1];

    my $num_words;
    my $linkage_count = 0;
    $self->{_start_position} = 0;
    $self->{_diagram_printed} = 0;

    # iterate through linkages
    foreach my $linkage ($sentence->linkages){
	$linkage_count++;
	last if $linkage_count > 1;

	$num_words = $linkage->num_words;

	print_stat $Lparser->get_diagram($linkage) if $PRINT_DIAGRAM;


	if( ref($self->{_fh}) && $PRINT_DIAGRAM_TO_FILE ){
	    $self->{_fh}->dump('DIAGRAM', $Lparser->get_diagram($linkage));
	    $self->{_diagram_printed} = 1;
	}

	# clean up temporary state information
	$self->reset;
	my $cool = $self->go($linkage);
	    
	if($cool){
	    print_stat "** COOL **\n";
	    print_stat $Lparser->get_diagram($linkage) if $PRINT_SUCCESSFUL_DIAGRAM;
	    print_stat $self->{_fh}->dump(
					  'SUCCESSFUL_DIAGRAM', 
					  $Lparser->get_diagram($linkage)
					  )
		if ref $self->{_fh} && $PRINT_SUCCESSFUL_DIAGRAM_TO_FILE;
	    
	    return 1;
	}
	else {
	    print_stat "FAILED\n";
	}
    }
}


sub accepted {
    my $self = shift;
    my $curr_state = shift;
    print_stat "CURR_STATE: $curr_state, ACCEPT_STATE: $self->{_final_state}\n";
    $curr_state == $self->{_final_state};
}

sub failed {
    $_[0]->{_failed};
}


sub item {
    my $self = shift;
    my @idx = @_;
    if(@_){
	@{$self->{_item}}[@_];
    }
    else {
	@{$self->{_item}};
    }
}

1;


__END__

