def get_all_possible_zuhe1(ori_array_size)

zuhe=(0..(ori_array_size-1)).to_a

index_array=[]

zuhe.each_index do |index|
	index_array<<[index]
end
#print index_array
return index_array

end

def get_all_possible_zuhe2(ori_array_size)


   iter_array=(0..(ori_array_size-1)).to_a
  
   possible_zuhe=[]
   total_size=ori_array_size

iter_array.each do |cycle|
 iter_array[cycle].upto(total_size-1).each do |i|
 	#first_index=i
 	#(i+1).upto(total_size-1).each do |j|
 		possible_zuhe<<[cycle,i]
 	#end
 end

end

puts possible_zuhe.size
possible_zuhe
end



def get_all_possible_zuhe3(ori_array_size)


   iter_array=(0..(ori_array_size-1)).to_a
  
   possible_zuhe=[]
   total_size=ori_array_size

iter_array.each do |cycle|
 iter_array[cycle].upto(total_size-1).each do |i|
 	#first_index=i
 	(i+1).upto(total_size-1).each do |j|
 		possible_zuhe<<[cycle,i,j]
 	end
 end

end

puts possible_zuhe.size
possible_zuhe
end


if $0==__FILE__
  start=Time.now
 a=get_all_possible_zuhe3(69)
 #puts a.size*4
 #get_all_possible_zuhe2(100)
 puts "cost time=#{Time.now-start}"
end