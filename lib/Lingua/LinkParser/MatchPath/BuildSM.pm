package Lingua::LinkParser::MatchPath::BuildSM;

use strict;
use Data::Dumper;
use List::Util qw(max);

#open STDERR, ">/dev/null";
sub print_stat {}

sub new {
    my $class = shift;
    my $template = shift;
    bless {
	_template => $template,
	_curr_state => 0,
	_prev_state => 0,
	_states => { 0 => '' },
	_state_stack => [ 0 ],
	_arc => {
	},
	_fh => undef, # reserved for dumping logs to file
	_accept_state => undef,
	_item => [],
    }, $class;
}

sub template { $_[0]->{_template} }

sub reset {
    my $self = shift;
    $self->{_curr_state} = 0;
    $self->{_prev_state} = 0;
    $self->{_failed} = undef;
    $self->{_visited} = undef;
    $self->{_item} = [];
    $self->{_state_stack} = [ 0 ];
    $self->{_wordptr} = undef;
    $self->{_label_num} = undef;
    $self->{_arc_stack} = undef;
    $self->{_start_position} = undef;
    $self->{_linkage}  = undef;
    $self->{_built_arc_stack} = undef;
}


sub dump_arc {
    my $arc = shift;
    foreach my $k ('next_state', sort keys %$arc){
	print_stat "  $k => ".Dumper($arc->{$k})."\n";
    }
}

sub dump_arcs {
    my $self = shift;
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 0;
    foreach my $state (sort { $a <=> $b } keys %{$self->{_arc}}){
	print_stat ">> STATE: $state\n";
	foreach my $arc (@{$self->{_arc}->{$state}}){
	    print_stat dump_arc($arc), $/x2;
	}
    }
}

sub arc_template {
    my %arg = @_;

    return { 
	next_state => $arg{next_state},

	branch_type => ($arg{branch_type} || 0),
	branch => $arg{branch},

	input_action => $arg{input_action},
	label => ($arg{label}),
	word => ($arg{word}),

	# this is reserved for negative branching
	failure => $arg{failure},
    }
}




sub add_state {
    my $self = shift;
    my %arg = @_;

    my $state = $arg{state};
    $state = max(keys %{$self->{_states}})+1 unless defined $state;

    $self->{_prev_state} = $self->{_curr_state};
    $self->{_curr_state} = $state;
    $self->{_states}->{$state} = '';
    $self->{_final_state} = $state if $arg{final};
    print_stat "ADD STATE $state\n";
}

sub push_state {
    my $self = shift;
    push @{$self->{_state_stack}}, $self->{_curr_state};
}

sub pop_state {
    my $self = shift;
    $self->{_curr_state} = pop @{$self->{_state_stack}};
}

sub add_arc {
    my $self = shift;
    my %arg = @_;

    print_stat "JOIN: $arg{join}\n";
    foreach my $prev_state (
			    $arg{join} && keys %{$self->{_tojoin}} ?
			    (keys %{$self->{_tojoin}})
			    :
			    ($self->{_prev_state})
			    ){
	print_stat "ADD ARC ($prev_state -> $self->{_curr_state})\n";

	push
	    @{$self->{_arc}
	      ->{
		  $prev_state
		  }},
		      arc_template(
				    'next_state' => $self->{_curr_state},
				    %arg,
				    'branch_type' => $self->{_branch_type},
				    'branch' => $self->{_branch},
				    'input_action' => $self->{_input_action},
				    'failure' => $self->{_failure},
				    );
    }

}

sub restore_prev_state {
    my $self = shift;
    $self->{_prev_state} = $self->{_pprev_state};
}

sub save_prev_state {
    my $self = shift;
    $self->{_pprev_state} = $self->{_prev_state};
}

sub set_accept_state {
    my $self = shift;
    $self->{_accept_state} = $self->{_curr_state};
}

1;
