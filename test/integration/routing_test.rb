require 'test_helper'

class RoutingTest < ActionDispatch::IntegrationTest
  def test_short_id
    data = <<-DATA
[{
  "name": "test",
  "ips": 10.1,
  "stddev": 0.3,
  "microseconds": 3322,
  "iterations": 221,
  "cycles": 16
}]
    DATA

    report = Report.create! report: data

    get "/#{report.short_id}"
    assert_equal 200, status
  end
end
