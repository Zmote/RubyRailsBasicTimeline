class User
  attr_accessor :firstname, :lastname

  def initialize(firstname, lastname)
    @firstname = firstname
    @lastname = lastname
  end
end

class AbsenceTime
  def initialize(from_date, to_date)
    @date_map = from_date.upto(to_date).inject(Hash.new) do |hash, date|
      hash[date.year] = {} if hash[date.year].nil?
      hash[date.year][date.month] = [] if hash[date.year][date.month].nil?
      hash[date.year][date.month] << date
      hash
    end
  end

  def days_total
    days = 0
    @date_map.each do |year, _|
      @date_map[year].each do |month, __|
        days += @date_map[year][month].length
      end
    end
    days
  end

  def days_in_year_total(year)
    return 0 if @date_map[year].nil?

    days = 0
    @date_map[year].each do |month, _|
      days += @date_map[year][month].length
    end
    days
  end

  def days_in_month_total(year, month)
    return 0 if @date_map[year].nil? && @date_map[year][month].nil?
    @date_map[year][month].length
  end

  def months_total
    months = -1
    @date_map.each do |year, _|
      @date_map[year].each do
        months += 1
      end
    end
    months
  end

  def years_total
    years = -1
    @date_map.each do |_, _|
      years += 1
    end
    years
  end

  def years_only
    years = []
    @date_map.each do |year, _|
      years << year
    end
    years
  end

  def summary
    years_hash = {}
    days_total = 0
    @date_map.each do |year, _|
      days_total_year = 0
      months_arr = []
      @date_map[year].each do |month, __|
        month_name = Date::MONTHNAMES[month][0..2]
        month_days = {}
        month_days[month_name] = days_in_month_total(year, month)

        months_arr << month_days
        days_total_year += @date_map[year][month].length
      end
      days_total += days_total_year
      years_hash[year] = {:months => months_arr, :total => days_total_year}
    end
    {:years => years_hash, :total => days_total}
  end

  def all
    @date_map
  end
end

module ApplicationHelper
  def dummy_users
    [
        User.new("Zafer", "Dogan"),
        User.new("Niyazi", "Dogan"),
        User.new("Pascal", "Muster"),
        User.new("Petra", "Polak"),
        User.new("Geralt", "of Riva"),
        User.new("Son", "Goku"),
        User.new("Naruto", "Uzumaki"),
        User.new("Su", "Yong"),
        User.new("Mariko", "Tsubasa"),
        User.new("Sailor", "Moon")
    ]
  end

  def render_absence_entries(from_date, to_date)
    columns = ''
    from_date.upto(to_date).each do |date|
      columns += wrap_in_column(render_day_entry_for(date, dummy_users))
    end
    columns.html_safe
  end

  def render_absence_time_box(name, width)
    "<div class='absences-time-box' style='width:calc(#{width} * var(--cell-size))'>
      <span class='time-text'>#{name}</span>
    </div>".html_safe
  end

  def render_absence_name(user)
    "<div class='absences-name'>
      <label>#{user.firstname} #{user.lastname}</label>
     </div>"
  end

  def render_absence_names(users)
    user_entries = ''
    users.each do |user|
      user_entries += render_absence_name(user)
    end
    user_entries.html_safe
  end

  private

  def wrap_in_column(content)
    "<div class='absence-column'>
      #{content}
     </div>"
  end

  def render_day_entry_for(date, users)
    days_header = "<div class='absence-header-cell noselect'>
                    <div class='absence-header'>
                      <p class='absence-day-name'>#{date.strftime("%A")[0..2]}</p>
                      <p>#{date.strftime("%d")}</p>
                    </div>
                   </div>"
    days = ''
    users.each do |user|
      days += '<div class="absence-cell"></div>'
    end
    days_header + days
  end
end
