require 'pi_piper'
include PiPiper

after :pin => 21, :goes => :high do
  puts "Button pressed"
end

PiPiper.wait
