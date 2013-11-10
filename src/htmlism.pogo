pogo = require 'pogo'
dslify = require 'dslify'

render (template, locals) =
    tree = evaluate (template) with (locals)
    render (tree) as html

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
        head = el
        if ((contents) is a string)
            el.children.push(contents)
        else if ((contents) is a number)
            el.children.push(contents.to string())
        else
            c = contents()
            if ((c) is a string) @{ el.children.push(c) }

        head = prev

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

render (tree) as html =
    if ((tree) is a string)
        tree
    else
        contents = tree.children.map @(child) @{ render (child) as html }
        "<#(tree.name)#(render (tree) attributes)>#(contents.join(''))</#(tree.name)>"

render (object) attributes =
    str = ""
    for @(attr) in (object.attrs)
        str = str + ' ' + attr + '="' + object.attrs.(attr) + '"'

    str

(object) is a string =
    typeof (object) == 'string'

(object) is a number =
    typeof (object) == 'number'
