circle = $.sammy("body", ->

  # Page
  class Page
    constructor: (@name, @title) ->

    render: ->
      document.title = "Circle - " + @title

      # Render content
      $("body").attr("id","#{@name}-page").html HAML['header'](renderContext)
      $("body").append HAML[@name](renderContext)
      $("body").append HAML['footer'](renderContext)

      # Sammy eats hashes, so we need to reapply it to land at the right anchor on the page
      @scroll(window.location.hash)

      # Apply polyfill(s) if they exists
      @polyfill() if @polyfill?

    load: ->
      self = this
      require [ "views/outer/#{@name}/#{@name}" ], () ->
        $ -> self.render()

    scroll: (hash) ->
      if hash == '' or hash == '#' then hash = "body"
      $('html, body').animate({scrollTop: $(hash).offset().top}, 0);

    display: ->
      if HAML? and HAML[@name]? @render() else @load()

  # Pages
  home = new Page("home", "Continuous Integration made easy")
  about = new Page("about", "About Us")
  privacy = new Page("privacy", "Privacy Policy")

  # Navigation
  @get "/", (context) -> home.display()
  @get "/about.*", (context) -> about.display()
  @get "/privacy.*", (context) -> privacy.display()

  # Polyfill Detection
  home.polyfill = ->
    if !Modernizr.input.placeholder then require [ "placeholder" ]

  about.polyfill = ->
    if !Modernizr.input.placeholder then require [ "placeholder" ]
  )

# Run the application
$ -> circle.run window.location.pathname
