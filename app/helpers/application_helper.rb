# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def streamlined_side_menus
    [
      ['Usuários', {:controller => 'users'}],
      ['Filmes', {:controller => 'movies'}],
      ['Notas', {:controller => 'ratings'}],
      ['Recomendações', {:controller => 'recommendations'}]
    ]
  end
end
