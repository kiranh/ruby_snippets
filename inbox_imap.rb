require "net/imap"
require "mail"

require "active_support/all"  # sort_by!

class Array
    def histogram ; self.sort.inject({}){|a,x|a[x]=a[x].to_i+1;a} ; end
end

server   = "imap.gmail.com"
username = "socialtangomailer@gmail.com"
password = "s0cialtang0"

boxes = ["INBOX"]  # list all the IMAP folders to include in the calculations
imap = Net::IMAP.new(server, 993, true, nil, false)
imap.login(username, password)
imap.create('[Gmail]/Archive')
boxes.inject([]) do |sum, box|
    imap.select("INBOX")
    imap.search(["ALL"]).each do |m|
      puts "BODY CONTENT BELOW"
      body = imap.fetch(m,'BODY[TEXT]')[0].attr['BODY[TEXT]']
      msg = imap.fetch(m,'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string msg
      body = mail.text_part.body
      from = mail.from
      puts mail.subject
      puts body
      puts from
      imap.copy(m,"[Gmail]/Archive")
      imap.store(m, "+FLAGS", [:Deleted])
    end
end
imap.logout()
imap.disconnect()


