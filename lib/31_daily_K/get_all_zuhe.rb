def get_two_zuhe(number)
	zuhe=[]
	0.upto(number-1).each do |i|
		zuhe<<[i,number-i]
	end

	zuhe
end

def get_three_zuhe(number)
	all_zuhe=[]
	0.upto(number).each do |i|
    new_zuhe= get_two_zuhe(i)
    new_zuhe.each do |array|
    	array<<10-(array[0]+array[1])
    	all_zuhe<< array unless array.size==0
    end
    print new_zuhe.to_s+"\n"
  end
  print "total size =#{all_zuhe.size} \n"
  print  all_zuhe
end


if $0==__FILE__
  get_three_zuhe(10)
end