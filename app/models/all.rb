require 'time'

class All < ApplicationRecord
  self.pluralize_table_names = false

  def self.update_contests
    # prepare contests
    all_contests = SITES[1..-1].map do |site|
      site.second.camelize.constantize.pluck(:name, :start_time, :duration, :in_24_hours, :status)
    end

    SITES[1..-1].each_with_index do |site, i|
      all_contests[i].each do |contest|
        contest << site.first
      end
    end

    all_contests = all_contests.flatten(1)

    all_contests.sort! do |a, b|
      Time.parse(a.second[(a.second.index('>') + 1)...a.second.index('<', 2)]) <=> Time.parse(b.second[(b.second.index('>') + 1)...b.second.index('<', 2)])
    end

    # delete old contests from database
    delete_all

    # add contests
    all_contests.each do |contest|
      create(name: contest.first,
             start_time: contest.second,
             duration: contest.third,
             in_24_hours: contest.fourth,
             status: contest.fifth,
             site: contest.last)
    end

    update_last_update 'all'
  end
end
