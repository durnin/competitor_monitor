# frozen_string_literal: true

require 'rails_helper'

feature "Create a group of competitor's products" do

  def add_competitor(name, link, asin)
    click_link 'Add Competitor'
    within('#new_competitor') do
      fill_in 'Name', with: name
      fill_in 'Link', with: link if link
      fill_in 'Product asin', with: asin if asin
    end
    click_button 'Save'
    expect(page).to have_content "Competitor #{name} successfully added"
  end

  def edit_group
    click_link 'Edit'
    within('#edit_group_1') do
      fill_in 'Name', with: "#{group_name} 2"
    end
    click_button 'Save'
    expect(page).to have_content "Group #{group_name} 2 successfully updated"
    click_link 'Cancel'
  end

  def delete_group
    find("a[alt=\"Delete #{group_name} 2\"]").click
    expect(page).to have_content "Group #{group_name} 2 successfully deleted"
  end

  def edit_competitor
    click_link competitor1[:name]
    click_link 'Edit'
    within('#edit_competitor_1') do
      fill_in 'Name', with: "#{competitor1[:name]} 2"
    end
    click_button 'Save'
    expect(page).to have_content "Competitor #{competitor1[:name]} 2 "\
      'successfully updated'
    click_link 'Cancel'
  end

  def delete_competitor
    find("a[alt=\"Delete #{competitor1[:name]} 2\"]").click
    expect(page).to have_content "Competitor #{competitor1[:name]} 2 "\
      'successfully deleted'
  end

  given(:group_name) { Faker::Company.name }
  given(:competitor1) do
    { name: Faker::Commerce.product_name, link: Faker::Internet.url }
  end
  given(:competitor2) do
    { name: Faker::Commerce.product_name, asin: Faker::Code.asin }
  end

  scenario 'creates a group with competitors, updates it and deletes it' do
    visit groups_path
    # Create group
    click_link 'New Group'
    within('#new_group') do
      fill_in 'Name', with: group_name
    end
    click_button 'Save'
    expect(page).to have_content "Group #{group_name} successfully created"
    # View group
    click_link group_name
    # Create competitors
    add_competitor(competitor1[:name], competitor1[:link], nil)
    add_competitor(competitor2[:name], nil, competitor2[:asin])
    # Edit competitor
    edit_competitor
    # Delete competitor
    delete_competitor
    # Edit group
    edit_group
    # Delete group
    delete_group
  end
end
