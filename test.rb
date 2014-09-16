def func1
   i=0
   while i<=4
      puts "func1 at: #{Time.now} #{i}"
      sleep(2)
      i=i+1
      Thread.stop if i == 2
   end
end

def func2
   j=0
   while j<=4
      puts "func2 at: #{Time.now} #{j}"
      sleep(1)
      j=j+1
      Thread.stop if j == 2
   end
end

puts "Started At #{Time.now}"
t3 = Thread.new{
    while true 
    end
  }
t1=Thread.new{func1()}
t2=Thread.new{func2()}

t1.join
t2.join
t3.join