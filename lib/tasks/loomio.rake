namespace :loomio do
  task set_montes_de_oca_as_default_group: :environment do
    User.all.each do |user|
      Membership.create(group_id: 1, user_id: user.id) if !user.groups.map(&:id).include?(1)
    end
  end
  task tail_call: :environment do
    RubyVM::InstructionSequence.compile_option = {
      :tailcall_optimization => true,
      :trace_instruction => false
    }
  end

  task send_proposal_closing_soon: :environment do
    Delayed::Job.enqueue ProposalsClosingSoonJob.new
  end

  task close_lapsed_motions: :environment do
    MotionService.close_all_lapsed_motions
  end

  task send_missed_yesterday_email: :environment do
    SendMissedYesterdayEmail.to_subscribers!
  end

  task generate_error: :environment do
    raise "Testing error reporting for rake tasks. Chill, no action requied if you see this"
  end

  task refresh_likes: :environment do
    progress_bar = ProgressBar.create( format: "(\e[32m%c/%C\e[0m) %a |%B| \e[31m%e\e[0m ", progress_mark: "\e[32m/\e[0m", total: Comment.count )

    Comment.find_each do |c|
      progress_bar.increment
      c.refresh_liker_ids_and_names!
    end
  end

  task fix_unread: :environment do
    puts "Recounting discussion reader counts"
    progress_bar = ProgressBar.create( format: "(\e[32m%c/%C\e[0m) %a |%B| \e[31m%e\e[0m ", progress_mark: "\e[32m/\e[0m", total: DiscussionReader.count )

    DiscussionReader.find_each do |dr|
      progress_bar.increment
      next unless dr.valid?
      next unless dr.discussion.present?
      next unless dr.user.present?
      dr.reset_counts!
    end
  end

  task tag_and_measure_cohorts: :environment do
    CohortService.tag_groups
    MeasurementService.measure_groups(Date.yesterday)
  end

  task measure_groups_lots: :environment do
    CohortService.tag_groups
    date = 10.weeks.ago.to_date
    while(date < Date.today) do
      puts 'hi'
      MeasurementService.measure_groups(date)
      puts "measured #{date}"
      date = date + 1.day
    end
  end
end
