# Home Page

Hey there!

This page should contain an introduction to the school, a sort of
school notice-board.

When a user logs in this page disappears.

## Customization
You can write this page in 2 ways:

- Editing this file in Markdown (`app/views/application/_unlogged.html.md`)
- Renaming this file in `_unlogged.html.erb` and write simple HTML

In both formats the ERB support is present, so you can write `<%% ruby code... %>`.
With this feature you can access to this variables:

```
<%= APP_CONFIG.to_yaml.html_safe %>
```

```
<%= APP_CONFIG.inspect.html_safe %>
```

For example, the text `<%%= APP_CONFIG['school']['full_name'] %>` will be replaced with
`<%= APP_CONFIG['school']['full_name'] %>`
