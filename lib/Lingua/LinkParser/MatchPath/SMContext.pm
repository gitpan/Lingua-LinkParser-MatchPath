package Lingua::LinkParser::MatchPath::SMContext;
use Data::Dumper;

sub print_stat{
}


sub ENTER_wordcapture {
    my $self = shift;
    $self->{_wordcapture} = 1;
    print_stat "ENTER wordcapture : $self->{_curr_state}\n";
}

sub LEAVE_wordcapture {
    my $self = shift;
    $self->{_wordcapture} = 0;
    print_stat "LEAVE wordcapture\n";
}

sub ENTER_BRANCH {
    my $self = shift;
    $self->{_branch} = 'E';
}

sub LEAVE_BRANCH {
    my $self = shift;
    $self->{_branch} = 'L';
}


sub CLEAR_BRANCH {
    my $self = shift;
    $self->{_branch} = undef;
}

sub POP_BRANCHTYPE {
    my $self = shift;
    $self->{_branch_type} = pop @{$self->{_branch_type_stack}};
}


sub ENTER_AT {
    my $self = shift;
    print_stat "ENTER AT\n";
    push @{$self->{_branch_type_stack}}, $self->{_branch_type};
    $self->{_branch_type} = 0;
    $self->ENTER_BRANCH;
}

sub LEAVE_AT {
    my $self = shift;
    print_stat "LEAVE AT\n";
    $self->LEAVE_BRANCH;
}


sub ENTER_POUND {
    my $self = shift;
    print_stat "ENTER POUND\n";
    push @{$self->{_branch_type_stack}}, $self->{_branch_type};
    $self->{_branch_type} = 1;
    $self->ENTER_BRANCH;
}
sub LEAVE_POUND {
    my $self = shift;
    print_stat "LEAVE POUND\n";
    $self->LEAVE_BRANCH;
}


sub ENTER_EXCLM {
    my $self = shift;
    print_stat "ENTER EXCLM\n";
    push @{$self->{_branch_type_stack}}, $self->{_branch_type};
    $self->{_branch_type} = 2;
    $self->ENTER_BRANCH;
}
sub LEAVE_EXCLM {
    my $self = shift;
    print_stat "LEAVE EXCLM\n";
    $self->LEAVE_BRANCH;
}




sub STORE_INPUT_ACTION {
    my $self = shift;
    print_stat "STORE INPUT ACTION\n";
    $self->{_input_action} = 'store';
}
sub LOAD_INPUT_ACTION {
    my $self = shift;
    print_stat "LOAD INPUT ACTION\n";
    $self->{_input_action} = 'load';
}
sub CLEAR_INPUT_ACTION {
    my $self = shift;
    print_stat "CLEAR INPUT ACTION\n";
    $self->{_input_action} = undef;
}


sub PUSH_PREV_STATE {
    my $self = shift;
    print_stat "PUSH PREVIOUS STATE $self->{_curr_state};\n";
    push @{$self->{_prev_state_stack}}, $self->{_curr_state};
}
sub LOAD_PREV_STATE {
    my $self = shift;
    $self->{_curr_state} = $self->{_prev_state_stack}->[-1];
    print_stat "LOAD PREVIOUS STATE $self->{_curr_state};\n";
}
sub POP_PREV_STATE {
    my $self = shift;
    print_stat "POP PREVIOUS STATE\n";
    pop @{$self->{_prev_state_stack}};
}


sub SAVE_TOJOIN_STATE {
    my $self = shift;
    print_stat "SAVE $self->{_curr_state} to join later\n";
    $self->{_tojoin}->{ $self->{_curr_state} } = '';
}
sub JOIN_STATES {
    my $self = shift;
    print_stat "JOIN ", join( q/ /, keys %{$self->{_tojoin}}), "\n"; 
}

sub SET_FAILURE {
    my $self = shift;
    print_stat "SET FAILURE\n";
    $self->{_failure} = 1;
}

sub CLEAR_FAILURE {
    my $self = shift;
    print_stat "CLEAR FAILURE\n";
    $self->{_failure} = undef;
}

1;
