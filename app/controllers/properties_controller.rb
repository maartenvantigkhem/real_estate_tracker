class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new

    if @property.update property_params
      flash[:notice] = 'Record updated.'
      redirect_to edit_property_path @property
    else
      flash.now[:error] = @property.errors.full_messages.to_sentence
      render :edit 
    end
  end

  def edit
    @property = Property.find params[:id]
  end

  def update
    @property = Property.find params[:id]

    if @property.update property_params
      flash[:notice] = 'Record updated.'
      redirect_to edit_property_path @property
    else
      flash.now[:error] = @property.errors.full_messages.to_sentence
      render :edit 
    end
  end

  private

  def property_params
    params.require(:property).permit(
      :address,
      :city,
      :state,
      :zip,
      :monthly_rental_income,
      :down_payment_percent,
      :sale_price,
      :operating_expenses_percent,
      :vacancy_percent,
      :loan_interest_percent,
      :loan_length_years,
      :sales_commission_percent
      )
  end

end
