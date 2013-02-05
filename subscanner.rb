#!/usr/bin env ruby
#----Subdomain Scanner
#-Original version by presenceDemon
# pp Socket.gethostbyname("localhost")[3].unpack("CCCC").join(".")
# pp Socket.gethostbyaddr([127,0,0,1].pack("CCCC"))

require 'socket'

def help() # Help for the people!
    puts """/--------------------------------------/
\\   Subdomain Scanner                  \\
/                                      /
\\ Original C version by presenceDemon  \\
/     Ruby version by Metasplotto      /
\\--------------------------------------\\
"""
    puts "\n\tUSAGE: #{$0} <domain>"
end

def scan(domain) # SCAN FUNCTION
begin #Error Handling
File.open("sublist", "r").each_line do |sub|
    begin
        line = sub.chomp!
        rawdata = Socket.gethostbyname("#{line}.#{domain}") # get the ipaddr via name
        ip = rawdata[3].unpack("CCCC").join(".") # from pointer to a readable IP address
        reverse = Socket.gethostbyaddr(rawdata[3]) # reverseDNS - IT DOES NOT WORK WITH CLOUDFLARE
        puts "#{line}.#{domain}\t\t#{ip}\t\t#{reverse[0]}"
        rescue SocketError # when a record is not found, handle exception
            #puts "NOT FOUND! - #{line}.#{domain}"
        end
    end
    rescue Errno::ENOENT # file missing
        puts "ERROR!! File sublist missing!!"
end

end

domain = ARGV[0]

if ARGV.length >= 1
    scan(domain)
else
    help()
end