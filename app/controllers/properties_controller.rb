class PropertiesController < ApplicationController

  def index
    @properties = Property.all

    @properties = @properties.sort_by {|obj| obj.irr_for_prop }.reverse
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
      render :new
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

  def destroy
    property = Property.find params[:id]

    if property.destroy
      flash[:notice] = 'The record has been deleted.'
      redirect_to action: :index
    else
      flash.now[:error] = 'Error deleting record'
      render :index
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
      :sales_commission_percent,
      :posting_url,
      :num_years_to_hold,
      :rent_price_increase_percent,
      :tax_rate_percent,
      :notes
      )
  end

end

