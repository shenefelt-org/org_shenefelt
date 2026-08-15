# app/controllers/client_contacts_controller.rb
class ClientContactsController < ApplicationController
  before_action :set_client_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_contacts, only: [:new, :create, :edit, :update]

  def index
    @client_contacts = ClientContact.includes(:contact).order(created_at: :desc)
  end

  def show
  end

  def new
    @client_contact = ClientContact.new(contact_id: params[:contact_id])
  end

  def create
    @client_contact = ClientContact.new(client_contact_params)

    if @client_contact.save
      redirect_to client_contacts_path, notice: "Client contact record created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client_contact.update(client_contact_params)
      redirect_to client_contacts_path, notice: "Client contact record updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client_contact.destroy
    redirect_to client_contacts_path, notice: "Client contact record deleted."
  end

  private

  def set_client_contact
    @client_contact = ClientContact.find(params[:id])
  end

  def set_contacts
    @contacts = Contact.order(created_at: :desc)
  end

  def client_contact_params
    params.require(:client_contact).permit(:contact_id, :notes)
  end
end