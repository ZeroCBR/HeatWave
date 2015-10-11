##
# The main application helper module.
# Provides methods for helping with views.
module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil

    link_to title,
            { sort: column, direction: direction(column) },
            'class' => css_class
  end

  def direction(column)
    column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
  end
end
