# frozen_string_literal: true

# Controller for Groups of Competitors
class GroupsController < ApplicationController
  before_action :set_group, only: [:show]

  def show; end

  def index
    @groups = []
  end

  def new
    @group = nil # Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to action: 'index', notice: "Group #{@group.name} "\
        'successfully created.'
    else
      flash[:error] = 'There were some errors while trying to create the '\
        'group.'
      render :new
    end
  end

  private

  def set_group
    @group = nil # Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def group_params
    params.require(:group).permit(:name)
  end
end
