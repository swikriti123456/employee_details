class EmploymentsController < ApplicationController
  before_action :get_employment_data, only: %i[ destroy ]


  def create
    @personal_data = PersonalData.find_by(id: employment_params[:personal_data_id])
    employment_params[:employer].each_with_index do |emp, index|
      @employment = Employment.new(employer: emp, date_started: employment_params[:date_started][index], date_ended: employment_params[:date_ended][index])
      @employment.personal_data_id = @personal_data.id
      @employment.save
    end

    respond_to do |format|
      format.html { redirect_to personal_datum_path(@personal_data) }
    end
  end

  def add_employment
    helpers.fields model: Employment.new do |f|
      render turbo_stream: turbo_stream.append(
        "add-employment",
        partial: "employments/employment_fields",
        locals: { f: f, first_employment: nil }
      )
    end
  end

  def destroy
    if @employment_data.destroy
      redirect_to root_path
    end
  end

  private

  def get_employment_data
     @employment_data = Employment.find(params[:id])
  end


  def employment_params
    params.require(:employment).permit(:personal_data_id, employer: [], date_started: [], date_ended: [])
  end
end
