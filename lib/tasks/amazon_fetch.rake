# frozen_string_literal: true

namespace :amazon do
  desc 'Scrapes from amazon competitors data for system groups'
  task scrape_groups: :environment do
    puts 'Executing amazon:scrape_groups, jobs for scraping each group will '\
    'be enqueued'
    Group.find_each do |group|
      FetchGroupDataJob.perform_later group
    end
  end
end
