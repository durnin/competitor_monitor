# frozen_string_literal: true

# Controller for Competitors
class CompetitorsController < ApplicationController
  before_action :set_group, only: %i[new]
  before_action :set_competitor, only: %i[show edit]

  def show; end

  def new
    @competitor = @group.competitors.build
  end

  def edit
    render :new
  end

  def create
    @competitor = Competitor.new(competitor_params)

    if @competitor.save
      flash[:notice] = "Competitor #{@competitor.name} successfully added."
      redirect_to group_path(@competitor.group)
    else
      flash[:error] = 'There were some errors while trying to create the '\
        'competitor.'
      render :new
    end
  end

  # def update
  #   respond_to do |format|
  #     if @competitor.update(competitor_params)
  #       format.html { redirect_to @competitor,
  #                     notice: 'Competitor was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @competitor }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @competitor.errors,
  #                            status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  # def destroy
  #   @competitor.destroy
  #   respond_to do |format|
  #     format.html { redirect_to competitors_url,
  #                   notice: 'Competitor was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_competitor
    @competitor = Competitor.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def competitor_params
    params.require(:competitor).permit(:name, :link, :product_asin, :group_id)
  end
end
