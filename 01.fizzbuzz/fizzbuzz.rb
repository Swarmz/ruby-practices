for i in 1..20
  puts case 
    when i % 3.0 == 0 && i % 5.0 == 0 then "fizzbuzz"
    when i % 3.0 == 0 then "fizz"
    when i % 5.0 == 0 then "buzz"
    else i
  end
end

# for i in 1..20
#   if i % 3.0 == 0 && i % 5.0 == 0
#     puts "fizzbuzz"    
#   elsif i % 3.0 == 0
#     puts "fizz"
#   elsif i % 5.0 == 0
#     puts "buzz"
#   else
#     puts "#{i}"
#   end
# end
