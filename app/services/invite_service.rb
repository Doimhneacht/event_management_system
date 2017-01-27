class InviteService

  def initialize(emails, event)
    @event = event
    @emails = emails
    @bad_emails = []
    @invitations = []

    check_emails
  end

  def return_possible_errors
    errors_json unless @bad_emails.empty?
  end

  def invite_users
    @invitations.each {|user| @event.users << user}
  end

  private

  def check_emails
    @emails.each do |email|
      user = User.find_by_email(email)
      if user
        @invitations << user
      else
        @bad_emails << email
      end
    end
  end

  def errors_json
    @bad_emails.map! {|email| "#{email} is not among registered emails"}
    bad_request(@bad_emails)
  end
end