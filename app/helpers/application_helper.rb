module ApplicationHelper
  # Render a general of the homepage
  # Params:
  #   - name: the title of the block
  #   - opt: the options to generate the block
  #      - description: the description of the block
  #      - buttons: an hash of the buttons of the group
  #         - key: the title of the button
  #         - value: an hash of properties
  #             - to: the destination path
  #             - type: the color of the button (success, danger, warning...)
  #             - method: the method of the request (get, post...)
  def home_block(name, opt = {})
    opt['description']  ||= ''
    opt['buttons']      ||= []

    content_tag :div, class: ['col-md-4', 'home-block'] do
      content_tag :div, class: ['home-block-content'] do
        home_block_content(name, opt)
      end
    end
  end

  def bootstrap_panel(title, content = '', &block)
    content += capture(&block) if block_given?
    return "" if content.gsub(/<\/?[^>]*>/, '').blank?

    data = <<EOF
<div class="col-md-6">
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">#{title}</h3>
    </div>
    <div class="panel-body">
      #{content}
    </div>
  </div>
</div>
EOF
    data.html_safe
  end

  # Format a date to DD/MM/YYYY
  def format_date(date)
    d = Date.parse date.to_s
    d.strftime '%d/%m/%Y'
  end

  # Return 'Yes' if value is true, 'No' if is false
  def yesno(value)
    value ? 'Yes' : 'No'
  end

  private
  # Render the content of a block, including the title, the description and the buttons
  def home_block_content(name, opt = {})
    content_tag(:h2, name) +
    content_tag(:p, opt['description']) +
    opt['buttons'].map { |name, opt| home_block_button(name, opt) }.join.html_safe
  end

  # Render a button of a block
  def home_block_button(name, opt)
    opt['to'] ||= ''
    opt['type'] ||= 'success'
    opt['method'] ||= 'get'
    content_tag :div, class: 'form-group' do
      link_to name, opt['to'], method: opt['method'], class: ['btn', "btn-#{opt['type']}", 'form-control']
    end
  end
end
