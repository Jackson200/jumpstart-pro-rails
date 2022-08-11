# Mailchimp API client
# http://localhost:3000/jumpstart/docs/integrations
#
# Example usage:
# Jumpstart::Clients.mailchimp.lists("List ID").members.create(body: {email_address: "foo@bar.com", status: "subscribed", merge_fields: {FNAME: "First Name", LNAME: "Last Name"}})

Gibbon::Request.api_key = Rails.application.credentials.dig(:mailchimp, :api_key)
Jumpstart::Clients.mailchimp = Gibbon::Request.new
