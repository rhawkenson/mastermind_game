# SubProblems 
# 1. Computer chooses a random order 
# 2. Player makes a guess
# 3. Computer sends feedback on player guess
#     'x' for exact answer 
#     'o' for right color, wrong position 
#     Return value is printed every round, updated each time
# 4. If player gets the answer, announce winner 
# 5. If player doesn't get the answer in 8 turns, computer reveals code
# 6. Points start at 8 and are reduced each round 

$symbol_options = ['!','@','#','$','%','&','*']

def computer_codemaster
  $computer_code = []
  4.times do 
    $computer_code += [$symbol_options.sample]
  end 
  $computer_code
end 

computer_codemaster()
  