

ready = ->

  if sigma?
    sigma_settings =
      minNodeSize: 5
      maxNodeSize: 32
      minEdgeSize: 0.1
      maxEdgeSize: 4
      mouseWheelEnabled: false
      enableCamera: false

    force_atlas2_config =
      slowDown: 2
      strongGravityMode: true
      gravity: 1

    # Create new Sigma instance in graph-container div (use your div name here)
    s = new sigma
      graph:
        nodes: []
        edges: []
      container: "graph-container"
      renderer:
        container: document.getElementById("graph-container")
        type: "canvas"
      settings: sigma_settings

    sigma.utils.pkg "sigma.canvas.nodes"
    sigma.canvas.nodes.border = (node, context, settings) ->
      prefix = settings("prefix") or ""
      size = node[prefix + "size"]
      context.beginPath()
      context.arc node[prefix + "x"], node[prefix + "y"], node[prefix + "size"], 0, Math.PI * 2, true
      context.lineWidth = size / 5
      context.strokeStyle = node.borderColor or if node.primary_focus
                                                  "#37A672"
                                                else if node.secondary_focus
                                                  "#4AC198"
                                                else
                                                  "#D1272E"
      context.stroke()
      context.fillStyle = node.color or "#FFF"
      context.fill()


    # first you load a json with (important!) s parameter to refer to the sigma instance
    baseUrl = null
    renderHashTag = (text) ->
      s.graph.clear()
      baseUrl = "/hash_tags/" + text
      renderFromJson baseUrl + ".json"

    window.onpopstate = (event) -> renderHashTag event.state.text

    bound = false
    jsonLoaded = false
    setTimeout (->
      unless jsonLoaded
        $("#hash_tag_explorer_hash_tag_list").css "margin-top", "auto"
        $("#hash_tag_explorer_hash_tag_list").show()
        $("#graph-container").hide()
    ), 2000

    renderFromJson = (path) ->
      sigma.parsers.json path, s, ->
        s.stopForceAtlas2()

        jsonLoaded = true
        return false unless $("#graph-container").is(":visible")

        # this below adds x, y attributes as well as size = degree of the node
        i = undefined
        nodes = s.graph.nodes()
        edges = s.graph.edges()
        secondary_length = _(nodes).select((n) -> n.secondary_focus).size()

        tertiary_length  = _(nodes).reject((n) -> (n.primary_focus or n.secondary_focus)).size()

        for node, i in nodes
          node.type = "border"
          node.label = node.text

          if node.primary_focus
            _.assign node,
              x: 0
              y: 0
              color: "#FFF"
              size: 25
          else
            if node.secondary_focus
              percentage = i / secondary_length
              factor = percentage * 2 * Math.PI + 0.3
              _.assign node,
                x: Math.cos(factor) * 0.5
                y: Math.sin(factor) * 0.5
                color: "#5AD1A8"
                size: 10
            else
              percentage = i / tertiary_length
              factor = percentage * 2 * Math.PI + 0.3
              _.assign node,
                x: Math.cos(factor)
                y: Math.sin(factor)
                color: "#E1373E"
                size: 5

        unless bound
          s.bind "clickNode", (e) ->
            window.location.href = '/hash_tags/' + e.data.node.text
        #    renderHashTag e.data.node.text
        #    history.pushState
        #      text: e.data.node.text
        #    , e.data.node.text, baseUrl

          bound = true

        max_edge_count = _(edges).pluck('count').max().value()

        for edge in edges
          factor = (edge.count / max_edge_count)

          edge.size = 0.2 * factor

          hex = ((factor * 150) + 50).toString(16)
          edge.color = "#" + hex + hex + hex

        # Refresh the display:
        s.refresh()

        s.configForceAtlas2 force_atlas2_config
        s.startForceAtlas2()


    renderFromJson "/hash_tags/explore/#{hash_tag}.json"

$(document).ready ready
$(document).on 'page:load', ready

