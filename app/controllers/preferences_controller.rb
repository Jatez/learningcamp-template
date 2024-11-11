class PreferencesController < ApplicationController
  include Pagy::Backend

  def index
    @preferences = Preference.all
    @pagy, @records = pagy(@preferences)
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(preference_params)
    if @preference.save
      redirect_to preferences_path, notice: 'Preference was successfully created.'
    else
      render :new, alert: 'There was an error creating the preference.'
    end
  end

  def show
    @preference = Preference.find(params[:id])
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  def update
    @preference = Preference.find(params[:id])
    if @preference.update(preference_params)
      redirect_to preferences_path, notice: 'Preference was successfully updated.'
    else
      render :edit, alert: 'There was an error updating the preference.'
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy
    redirect_to preferences_path, notice: 'Preference was successfully deleted.'
  end

  private

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end