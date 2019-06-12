class User
  attr_accessor :firstname, :lastname

  def initialize(firstname, lastname)
    @firstname = firstname
    @lastname = lastname
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

  def render_absence_entries(fromDate, toDate)
    columns = ''
    fromDate.upto(toDate).each do |date|
      columns += wrap_in_column(render_day_entry_for(date, dummy_users))
    end
    columns.html_safe
  end

  def render_absence_name(user)
    "<div class='absences-name'>
      <label>#{user.firstname} #{user.lastname}</label>
     </div>"
  end

  def render_absence_names(users)
    user_header_entry = "<div class='absences-name absences-empty-name'>
      <label></label>
     </div>"
    user_entries = ''
    users.each do |user|
      user_entries += render_absence_name(user)
    end
    (user_header_entry + user_entries).html_safe
  end

  private

  def wrap_in_column(content)
    "<div class='absence-column'>
      #{content}
     </div>"
  end

  def render_day_entry_for(date, users)
    header_cell = "<div class='absence-header-cell noselect'>
                    <div class='absence-header'>
                      <p class='absence-day-name'>#{date.strftime("%A")[0..2]}</p>
                      <p>#{date.strftime("%d")[0..2]}</p>
                    </div>
                   </div>"
    day_cells = ''
    users.each do |user|
      day_cells += '<div class="absence-cell"></div>'
    end
    header_cell + day_cells
  end
end
