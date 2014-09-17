def text_display(text, f_rate, sleep_time=0, splitted="")
  display = 0
  text=text.split(splitted)
  text_length = text.length
  display_string = ""
  until display == text_length
    wipe 
    yield if block_given?
    display_string << text.shift << splitted
    print "\r\n#{display_string}"
    sleep(f_rate)
    display += 1
  end
  sleep(sleep_time)
  wipe
end
  
def wipe
  system "clear"
end
