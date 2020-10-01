class ReportsController < ApplicationController
  include ReportsHelper

  protect_from_forgery :except => [:create]

  DATA_KEY = %W!central_tendency error name ips stddev microseconds iterations cycles!

  def create
    data = request.body.read

    begin
      input = JSON.parse data
    rescue Exception => err
      logger.fatal("Error: #{err.message} || #{data}")
      head 400
      return
    end

    ary = input["entries"]

    unless ary.kind_of? Array
      head 400
      return
    end

    ary.each do |j|
      needed = DATA_KEY.dup

      j.keys.each do |k|
        if DATA_KEY.include? k
          needed.delete k
        else
          head 400
          return
        end
      end

      unless needed.empty?
        head 400
        return
      end
    end

    rep = Report.create report: JSON.generate(ary)

    options = input["options"] || {}

    if options["compare"]
      rep.compare = true
    end

    rep.save

    render json: { id: rep.short_id }
  end

  def show
    @report = Report.find_from_short_id params[:id]

    fastest = nil
    fastest_val = nil
    note_high_stddev = false

    @report.data.each do |part|
      if !fastest_val || part["ips"] > fastest_val
        fastest = part
        fastest_val = part["ips"]
      end

      if stddev_percentage(part) >= 5
        note_high_stddev = true
      end
    end

    @note_high_stddev = note_high_stddev
    @fastest = fastest
  end
end
