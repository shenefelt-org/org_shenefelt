class ContactMailer < ApplicationMailer
    def submission(contact)
        @contact = contact

        mail(
            to: "notifications@shenefelt.org",
            reply_to: @contact.email,
            subject: "Contact Form Submission: #{@contact.name}"
        )
    end
end
