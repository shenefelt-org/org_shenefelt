class ContactMailer < ApplicationMailer
    def submission(contact)
        @contact = contact

        mail(
            to: "notifications@shenefelt.org",
            reply_to: @contact.email,
            subject: "new submission form from #{@contact.name}"
        )
    end
end
