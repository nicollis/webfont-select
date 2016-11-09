(($) ->
  loadedFonts = {}
  $.widget 'webfont.wfselect', {
    options: {
      # Default use fonts list if one is not provided
      fonts: {
        google: {
          # families: ['Droid Sans', 'Signika'] # supported font list
          families: [{name: 'Droid Sans', url: null}, {name: 'Signika', url: null}],
          url_generation: {base_url: 'https://fonts.googleapis.com/css?family=$font', space_char: '+'}
        },
        # custom: {
        #   families: ['My Font'],
        #   urls: ['/fonts.css']
        # }
      },
      merge_list: false,
      load_all_fonts: false,
      default_font_name: {type: 'google', name: 'Signika'}
    }
    
    _create: ->
      self = this
      options = @options
      element = @element
      useFonts = options.fonts || @options.fonts
      element.addClass('webfont-input').wrap $('<div/>').addClass('webfont-wrapper')
      element.on('keyup paste', {instance: self}, self._searchFontList)
      @wrapper = element.closest('.webfont-wrappers')
      element.after self._createFontList(useFonts, @options.merge_list).hide()
      self._selectFontByName element.val()
      self.toggle = $('<div/>').addClass('ui-icon ui-icon-triangle-1-s').insertAfter(element)
      self._bindHandlers()
      self._loadAllFonts() if options.load_all_fonts
      return
    
    _createFontList: (fonts_options, merge = false) ->
      @fontList = $('<ul/>').addClass 'webfont-list'
      self = this
      fonts = @_createFontObjects(fonts_options, merge)
      $.each fonts, (index, font) ->
        $('<li/>')
          .html(font.font)
          .data('font_name', font.font)
          .data('font_type', font.type)
          .data('font_url', font.url)
          .css(self._fontToStyle(font.font))
          .appendTo(self.fontList)
        return
      @fontList
      
    _searchFontList: (event) ->
      self = event.data.instance
      current_input = $(this).val()
      fonts_options = self.options.fonts
      first_font_name = null
      filtered_fonts_options = $.extend(true, {}, fonts_options)
      $.each filtered_fonts_options, (key, families_object) ->
        families = families_object['families']
        filtered_fonts_options[key]['families'] = families.filter(self._filterFontList, current_input)
        return
      self.element.nextAll().remove()
      self.element.after self._createFontList(filtered_fonts_options, self.options.merge_list)
      self._selectFontByName(self._getFirstFontInList(filtered_fonts_options), (if event.keyCode == 13 then false else true))
      self._bindHandlers()
      return
      
    _filterFontList: (font_obj) ->
      if typeof font_obj == 'string'
        return font_obj.toLowerCase().indexOf(this.toString().toLowerCase()) >= 0
      else
        return font_obj.name.toLowerCase().indexOf(this.toString().toLowerCase()) >= 0
        
    _getFirstFontInList: (fonts_options) ->
      first_font_families = fonts_options[Object.keys(fonts_options)[0]].families
      return null if first_font_families.length < 1
      font_obj = first_font_families[0]
      if typeof font_obj == 'string'
        return font_obj
      else
        return font_obj.name
      
    _createFontObjects: (fonts_options, merge = false) ->
      fonts_list = []
      self = this
      $.each fonts_options, (key, families_object) ->
        t = families_object.families.map (font) ->
          if typeof font == 'string'
            return {font: font, type: key, url: self._generateFontUrl(fonts_options, key, font)}
          else
            return {font: font.name, type: key, url: font.url || self._generateFontUrl(fonts_options, key, font.name)}
        fonts_list = fonts_list.concat t
        return
      if merge
        fonts_list = fonts_list.sort (a, b) ->
          return a.font > b.font
      return fonts_list
      
    _generateFontUrl: (fonts_options, font_type, font_name) ->
      return null if fonts_options[font_type].url_generation == undefined
      font_name = font_name.split(" ").join(fonts_options[font_type].url_generation.space_char) if fonts_options[font_type].url_generation.space_char != undefined
      fonts_options[font_type].url_generation.base_url.replace('$font', font_name)
      
    _fontToStyle: (fontName) ->
      font_and_weight = fontName.split ":"
      return {
        'font-family': @_readableFontName(font_and_weight[0]),
        'font-weight': (font_and_weight[1] || 400)
      }
      
    _readableFontName: (font_name) ->
      font_name.replace /[\+|:]/g, ' '
      
    _selectFontByName: (name, highlight_only = false) ->
      fonts = @fontList.find 'li'
      match = $.grep fonts, (li, i) ->
        ($(li).data('font_name') == name)
      if match.length
        @_selectFontListItem $(match).first(), highlight_only
        return true
      else
        unless @options['default_font_name'] == undefined
          @element
              .attr('font_url', @_generateFontUrl(@options['fonts'], @options['default_font_name']['type'], @options['default_font_name']['name']))
              .trigger('change')
              .trigger('default')
        return false
      
    _selectFontListItem: (li, highlight_only = false) ->
      return null if li.hasClass 'selected'
      @fontList.find('li.selected').removeClass('selected')
      li = $(li).addClass('selected')
      font_name = li.data('font_name')
      font_type = li.data('font_type')
      font_url = li.data('font_url')
      styles = @_fontToStyle(font_name)
      @element.css(styles)
      @_loadFonts([{font: font_name, type: font_type}])
      if @element.val() != font_name
        @element
            .attr('font_url', font_url)
            .trigger('change')
      unless highlight_only
        if @element.val() != font_name
          @element
              .val(font_name)
        @_toggleFontList(false)
      @_trigger('change', null, styles)
      return
      
    _loadFonts: (fonts) ->
      font_array =  $.grep fonts, (font_name) ->
        return loadedFonts[font_name.font]
      , true
      if !font_array.length
        return null
      source = {}
      $.each font_array, (index, fonts) ->
        loadedFonts[fonts.font] = true
        source[fonts.type] = {} if Object.keys(source).indexOf(fonts.type) == -1
        source[fonts.type]['families'] = [] if Object.keys(source[fonts.type]).indexOf('families') == -1
        source[fonts.type]['families'].push fonts.font
        return
      WebFont.load source
      return
      
    _loadAllFonts: ->
      fonts_list = [{}]
      font_list_index = 0
      font_list_counter = 0
      $.each this.options.fonts, (key, families_object) ->
        fonts_list[font_list_index][key] = {families: []}
        $.each families_object['families'], (i, font) ->
          font_list_counter++
          if font_list_counter >= 40
            font_list_index++
            font_list_counter = 0
            fonts_list[font_list_index] = {}
            fonts_list[font_list_index][key] = {families: []}
          if typeof font == 'string'
            fonts_list[font_list_index][key]['families'].push font
            loadedFonts[font] = true
          else
            fonts_list[font_list_index][key]['families'].push font.name
            loadedFonts[font.name] = true
      timeout = 0
      $.each fonts_list, (i, list) ->
        setTimeout (->
          WebFont.load list
          return
          ), timeout += 200
        
      
    _loadVisibleFonts: ->
      if !@fontList.is(':visible')
        return null
      list_top = @fontList.scrollTop()
      list_height = @fontList.height()
      list_bottom = list_top + list_height
      fonts = @fontList.find('li')
      fontsToLoad = []
      $.each fonts, (index, font) ->
        font = $(font)
        font_top = font.position().top
        font_bottom = font_top + font.outerHeight()
        if (font_bottom >= 0) && (font_top < list_height)
          fontsToLoad.push({font: font.data('font_name'), type: font.data('font_type')})
          return
      @_loadFonts(fontsToLoad)
      return
      
    _toggleFontList: (bool) ->
      if bool
        @wrapper.css {'z-index': 999999}
        @fontList.show()
        @_loadVisibleFonts()
        selectedFont = @fontList.find('li.selected')
        if selectedFont.length
          @fontList.scrollTop selectedFont.position().top
      else
        @wrapper.css {'z-index': 'auto'}
        @fontList.hide()
      return
      
    _bindHandlers: ->
      self = this
      loadTimeout = null
      $('html').bind 'click.webfont', (event) ->
        self._toggleFontList false
        return
      open_font_list = (event) ->
        self._toggleFontList true
        event.stopPropagation()
        return
      @element.bind 'click.webfont', open_font_list
      @toggle.bind 'click.webfont', open_font_list
      @fontList.bind 'scroll.webfont', (event) ->
        window.clearTimeout loadTimeout
        loadTimeout = window.setTimeout ->
          self._loadVisibleFonts()
          return
        , 250
        return
      .bind 'click.webfont', (event) ->
        target = $(event.target)
        if !target.is('li')
          return null
        self._selectFontListItem(target)
        return
      return
      
    destory: ->
      @fontList.remove()
      @toggle.remove()
      @element
          .removeClass('webfont-input')
          .removeAttr('readonly')
          .unbind('click.webfont')
          .unwrap()
      $('html').unbind('click.webfont')
      $.Widget.prototype.destory.call(this)
      return
    }
) jQuery