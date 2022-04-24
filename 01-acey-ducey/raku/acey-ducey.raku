say q:to/END/;
ACEY-DUCEY IS PLAYED IN THE FOLLOWING MANNER
THE DEALER (COMPUTER) DEALS TWO CARDS FACE UP
YOU HAVE AN OPTION TO BET OR NOT BET DEPENDING
ON WHETHER OR NOT YOU FEEL THE CARD WILL HAVE
A VALUE BETWEEN THE FIRST TWO.
END

role CardValue { has $.value; }
my @deck = gather for |(2..10), |<J Q K A> {
    when 'A' { take $_ but CardValue(1); }
    when 'J' { take $_ but CardValue(11); }
    when 'Q' { take $_ but CardValue(12); }
    when 'K' { take $_ but CardValue(13); }
    default { take $_ but CardValue($_); }
}

class Game { has $.balance is rw = 100; }

my $game-state = Game.new;

loop {
    say "YOU NOW HAVE {$game-state.balance} DOLLARS.";
    say "";
    say "HERE ARE YOUR NEXT TWO CARDS:";
    my @choices = @deck.pick(3);
    my $final-card = @choices.pop;
    @choices .= sort: *.value; 
    .say for @choices;

    my Cool $bet;
    loop {
        $bet = prompt "WHAT IS YOUR BET? ";
        last if $bet ~~ /^ \d+ $/ and 0 <= $bet <= $game-state.balance;
        say "BET MUST BE GREATER THAN OR EQUAL TO 0 AND LESS THAN {$game-state.balance}";
    }
    
    $game-state.balance -= $bet;
    
    if @choices[0].value < $final-card.value < @choices[1].value {
        say "YOU WIN!";
        $game-state.balance += $bet * 2;
    } else {
        say "YOU LOSE.";
    }

    last if $game-state.balance <= 0;
}
