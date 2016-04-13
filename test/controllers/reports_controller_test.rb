require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "validates the data json" do
    data = "nope"
    post :create, data

    assert_equal "400", @response.code
  end

  test "validates the data json as valid benchmark data" do
    data = <<-DATA
{
  "entries":
    [{
      "name": "test",
      "ips": 10.1,
      "stddev": 0.3,
      "microseconds": 3322,
      "iterations": 221,
      "cycles": 16
    }]
}
    DATA
    post :create, data

    assert_equal "200", @response.code

    rep = JSON.parse @response.body

    report = Report.find_from_short_id rep["id"]
    assert_equal data, report.report
  end

  test "errors on unknown data keys" do
    data = <<-DATA
{
  "entries":
    [{
      "name": "test",
      "ipx": 10.1,
      "stddev": 0.3,
      "microseconds": 3322,
      "iterations": 221,
      "cycles": 16
    }]
}
    DATA
    post :create, data

    assert_equal "400", @response.code
  end

  test "errors out if there are keys missing" do
    data = <<-DATA
{
  "entries":
    [{
      "name": "test"
    }]
}
    DATA
    post :create, data

    assert_equal "400", @response.code

  end
end
