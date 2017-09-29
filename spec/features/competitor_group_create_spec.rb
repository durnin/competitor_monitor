# frozen_string_literal: true

require 'rails_helper'

feature "Create a group of competitor's products" do

  def add_competitor(name, link, asin)
    click_button 'Add Competitor'
    within('#new_competitor') do
      fill_in 'Name', with: name
      fill_in 'Link', with: link if link
      fill_in 'Product ASIN', with: asin if asin
    end
    click_button 'Create Competitor'
    expect(page).to have_content "Competitor #{competitor1[:name]}"\
                                   'successfully added'
  end

  given(:group_name) { Faker::Company.name }
  given(:competitor1) do
    { name: Faker::Company.name, link: Faker::Internet.url }
  end
  given(:competitor2) do
    { name: Faker::Company.name, asin: Faker::Code.asin }
  end

  scenario 'creates a group with competitors' do
    visit groups_path
    click_link 'New Group'
    within('#new_group') do
      fill_in 'Name', with: group_name
    end
    click_button 'Save'
    expect(page).to have_content "Group #{group_name} successfully created"
    click_link group_name # link to show the group
    add_competitor(competitor1[:name], competitor1[:link], nil)
    add_competitor(competitor2[:name], nil, competitor2[:asin])
  end
end
