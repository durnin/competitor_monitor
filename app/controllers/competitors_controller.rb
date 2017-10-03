# frozen_string_literal: true

# Controller for Competitors
class CompetitorsController < ApplicationController
  before_action :set_group, only: %i[new]
  before_action :set_competitor, only: %i[show edit update destroy]

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

  def update
    if @competitor.update(competitor_params)
      flash[:notice] = "Competitor #{@competitor.name} successfully updated."
      redirect_to @competitor
    else
      flash[:error] = 'There were some errors while trying to update the '\
        'competitor.'
      render :edit
    end
  end

  def destroy
    name = @competitor.name
    group_id = @competitor.group_id
    @competitor.destroy
    flash[:notice] = "Competitor #{name} successfully deleted."
    redirect_to group_url(group_id)
  end

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
