# frozen_string_literal: true

# Controller for Groups of Competitors
class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  def show; end

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def edit
    render :new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      flash[:notice] = "Group #{@group.name} successfully created."
      redirect_to action: 'index'
    else
      flash[:error] = 'There were some errors while trying to create the '\
        'group.'
      render :new
    end
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "Group #{@group.name} successfully updated."
      redirect_to @group
    else
      flash[:error] = 'There were some errors while trying to update the '\
        'group.'
      render :edit
    end
  end

  def destroy
    name = @group.name
    @group.destroy
    flash[:notice] = "Group #{name} successfully deleted."
    redirect_to groups_url
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def group_params
    params.require(:group).permit(:name)
  end
end
