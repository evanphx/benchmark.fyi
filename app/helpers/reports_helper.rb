module ReportsHelper
  def format_ips(value)
    scale = (Math.log10(value) / 3).to_i
    suffix = case scale
             when 1; 'k'
             when 2; 'M'
             when 3; 'B'
             when 4; 'T'
             when 5; 'Q'
             else
               # < 1000 or > 10^15, no scale or suffix
               scale = 0
               ' '
             end
    "%10.3f#{suffix}" % (value.to_f / (1000 ** scale))
  end

  def times_slower(best, cur)
    best_low = best["ips"] - best["stddev"]
    report_high = cur["ips"] + cur["stddev"]
    overlaps = report_high > best_low 

    if overlaps
      return "-"
    else
      "%.2fx" % (best["ips"] / cur["ips"])
    end
  end

  def stddev_percentage(part)
    100.0 * (part["stddev"] / part["ips"])
  end

  def format_stddev(part)
    "%4.1f%%" % stddev_percentage(part)
  end
end
