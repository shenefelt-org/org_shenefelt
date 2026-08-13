class ContactsController < ApplicationController
    def new
        @contact = Contact.new 
    end

    
    def create
        @contact = Contact.new(contact_params)

        if @contact.save 
            ContactMailer.submission(@contact).deliver_later(wait: 1.minute)

            redirect_to root_path, notice: "I got your message! Talk soon"
        else
            render :new, status: :unprocessable_entity
        end

    end

    private 
    
    def contact_params
        params.require(:contact).permit(:name, :email, :message)
    end
end
