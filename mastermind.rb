# SubProblems 
# 1. Computer chooses a random order 
# 2. Player makes a guess
#     Evaluate if the guess is valid: Corrent length, correct symbols
#     Evaluate if the guess matches the computer's code 
# 3. Computer sends feedback on player guess
#     'x' for exact answer 
#     'o' for right color, wrong position 
#     Return value is printed every round, updated each time
# 4. If player gets the answer, announce winner 
# 5. If player doesn't get the answer in 8 turns, computer reveals code
# 6. Points start at 8 and are reduced each round 



# ------- Project Code -------
$symbol_options = ['!','@','#','$','%','&','*','^','?']
class Game
  $rounds = 0
  $game_end = false
  $points = 9

# Explain the rules to the user
  def self.rules
    puts "\n\nWelcome to MASTERMIND! You are tasked with creating an unbreakable code -OR- guessing" 
puts "an unbreakable code. If you choose to create the code, you will make a 4-character code using only "
puts "the following symbols: #{$symbol_options}, and the computer will have "
puts "8 turns to crack the code. If you choose to break the code, the computer will create a secret " 
puts "code, using the same symbols, and you will have 8 turns to break the code. "
    puts "\n\nWould you like to create the code or break the code?\n" 
    
    self.start
  end 

#Prompt the user to create their own code or guess the computer's code
  def self.start
    puts "Enter 'create' to create the code or 'break' to break the computers's code: "
    user_choice = gets.chomp
    role = user_choice.downcase
    
    if role == "create"
      computer = Codebreaker.new('computer')
      #player_codemaster
    elsif role == "break"
      Codemaster.new
      Codemaster.computer_codemaster    
    else 
      puts "\nPlease enter a valid choice."
      Game.start
    end 
  end 
end 


#Class names refer to the role of the computer. If the player chooses to break the code, the computer is the 'Codemaster'

class Codemaster
#Computer randomly selects 3 symbols from the $symbol_options (repeats are allowed)
  def self.computer_codemaster
    $computer_code = []
    4.times do 
      $computer_code += [$symbol_options.sample]
    end 
    $computer_code
    self.continue()
  end 
  def self.continue
    Codebreaker.new('player')
  end 
end

#Class names refer to the role of the computer. If the player chooses to create the code, the computer is the 'Codebreaker'
class Codebreaker 
  def initialize(name)
    @name = name

    if @name == 'player'
      player_guess

    elsif @name == 'computer'
      player_codemaster
    else
      puts 'this shit dont work'
    end 
  end

  def player_codemaster
    puts "Symbols: ! @ # $ % ^ & * ?"
    puts "Please select your secret code:"
    code = gets.chomp.split(//)

    if code.length == 4
      if code.all?{|symbol| $symbol_options.include?(symbol)}
        $player_code = code
      else 
        puts "\n\nINVALID CODE. Please re-enter your code. 
    You must enter 4 symbols and may ONLY use the following:"
        self.player_codemaster()
      end 
    else 
    puts "\n\nINVALID CODE. Please re-enter your code. 
  You must enter 4 symbols and may ONLY use the following:"
      self.player_codemaster()
    end 
    computer_guess()
  end


# Player is prompted to enter their guess, which is converted from a string to an array
  def player_guess 
    if $rounds == 8
      puts "GAME OVER. The code you were trying to break was #{$computer_code}. You have earned 0 points."

    else 
      puts "Symbols: ! @ # $ % ^ & * ?"
      puts "Enter your guess:"
      $guess = gets.chomp.split(//)
      guess_evaluation($guess)
    end
  end 
$guess_bank = []
#Random computer guess is generated
def computer_guess
  comp_guess = ['']
  
# If rounds are all spent and the correct answer has not been guess, the game ends and the player wins. 
  if $rounds >= 8
    puts "GAME OVER. The computer was not able to break your code!\n\n"

# The first round computer guess is completely random  
  elsif $rounds == 0
    4.times do 
      comp_guess += [$symbol_options.sample]
    end 
    puts "Secret code is:   #{$player_code.join}"
    puts "Computer guessed: #{comp_guess.join}"
    code_check(comp_guess, $player_code)
    
# 2nd-8th round guesses are selected by either keeping previous correct answers or pulling from an array (see above: $guess_bank) of symbols that are in the code but not in the correct position
  else 
    i = 0
    while i < 4
      if $feedback[i] == 'x'
        comp_guess[i] = $previous_guess[i]
        
      elsif $feedback[i] == 'o'
        $guess_bank += [$previous_guess[i]]
        comp_guess[i] = $symbol_options.sample
      else
        if $guess_bank.length > 0
          comp_guess[i] = $guess_bank.sample
        else 
          comp_guess[i] = $symbol_options.sample
        end
      end 
      i += 1
    end 
    puts $guess_bank.length
    puts "Secret code is:   #{$player_code.join}"
    puts "Computer guessed: #{comp_guess.join}"
    code_check(comp_guess, $player_code)
  end 
end

#The player's guess is evaluated - must be correct length and only contains $symbol_options
  def guess_evaluation(guess)
    if guess.length == 4
      if guess.all?{|symbol| $symbol_options.include?(symbol)}
        code_check($guess, $computer_code)
      else 
        puts "\n\nINVALID CODE. Please re-enter your code. 
    You must enter 4 symbols and may ONLY use the following:"
        player_guess()
      end 
    else 
    puts "\n\nINVALID CODE. Please re-enter your code. 
  You must enter 4 symbols and may ONLY use the following:"
      player_guess()
    end 
  end 

# The Player's guess is compared to the computer's code; 'x' is return for exactly correcty symbols, 'o' is returned for symbols that are in the code but not in the position they are currently in, and '_' is return for symbols that are not in the code at all 
  def code_check(guess, code)
    $rounds += 1
    $points -= 1 
    x = 0
    $feedback = []
    while x < guess.length
      if guess[x] == code[x]
        $feedback += ['x']
      elsif code.include?(guess[x])
        $feedback += ['o']
      else 
        $feedback += ['_']
      end
      x += 1
    end 
    puts $feedback.join
    code_broken(guess, code)
  end 


# If the guess perfectly matches the computer's code, the game ends 
  def code_broken(guess, code)

# If the computer is the codemaster, either end the game or keep getting the player's guesses
    if code == $computer_code  
      if code == guess
        puts "\nYOU WON!"
        puts "You have earned #{$points} points\n\n"
      else 
        player_guess()
      end 
#If the computer is the code guesser, either end the game or keep getting the player's guesses
    elsif code == $player_code
      
      if code == guess
        puts "\nCOMPUTER WON!"
        puts "Computer earned #{$points} points\n\n"
      else 
        puts "Press enter to continue"
        gets.chomp
        $previous_guess = code
        self.computer_guess()
      end 
    else 
      puts "the secret code is not working"
    end 
  end 

end 


Game.rules
