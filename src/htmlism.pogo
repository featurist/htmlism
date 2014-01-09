pogo = require 'pogo'
dslify = require 'dslify'
renderer = require './html_renderer'

render (template, locals) =
    tree = evaluate (template) with (locals)
    renderer (tree)

exports.render = render

tags = "a abbr address article aside audio b bdi bdo blockquote body button
        canvas caption cite code colgroup datalist dd del details dfn div dl dt em
        fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
        html i iframe ins kbd label legend li map mark menu meter nav noscript object
        ol optgroup option output p pre progress q rp rt ruby s samp script section
        select small span strong style sub summary sup table tbody td textarea tfoot
        th thead time title tr u ul video".split r/\s/g

evaluate (template) with (locals) =

    dsl = { }
    head = { children = [] }

    element (name, attrs, contents) =
        el = { name = name, attrs = attrs, children = [] }
        head.children.push (el)
        prev = head
        head := el
        if (contents :: String)
            el.children.push(contents)
        else if (contents :: Number)
            el.children.push(contents.to string())
        else
            c = contents()
            if (c :: String) @{ el.children.push(c) }

        head := prev

    define element (name) =
        dsl.(name) =
            fn () =
                if (arguments.length == 2)
                    element (name, arguments.0, arguments.1)
                else
                    element (name, {}, arguments.0)

    for each @(name) in (tags)
        define element (name)

    for @(local) in (locals) @{ dsl.(local) = locals.(local) }

    execute (template) against (dsl)

    head.children.0

execute (template) against (dsl) =
    js = pogo.compile(template, in scope: false)
    fn = new (Function (js))
    transformed = dslify.transform(fn)
    transformed(dsl)

