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
        content_tag(:h2, name) +
        content_tag(:p, opt['description']) +
        opt['buttons'].map do |name, opt|
          opt['to'] ||= ''
          opt['type'] ||= 'success'
          opt['method'] ||= 'get'
          content_tag :div, class: 'form-group' do
            button_to name, opt['to'], method: opt['method'], class: ['btn', "btn-#{opt['type']}", 'form-control']
          end
        end.join.html_safe
      end
    end
  end
end
