class PagesController < ApplicationController
  def contacts
  end

  def send_message
    if validate_presence(params[:name], params[:email], params[:message])
      flash.now[:notice] =  "Your message was successfully sent.\n" \
                            "We will get back to you shortly"
      render 'message_sent'
    else
      flash.now[:error] = "All required fields must be filled in."
      render 'contacts'
    end
  end

  private

  def validate_presence(*fields)
    fields.all? { |field| !field.empty? }
  end
end
