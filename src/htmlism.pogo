pogo = require 'pogo'
fs = require 'fs'

tags = "a abbr address article aside audio b bdi bdo blockquote body button
        canvas caption cite code colgroup datalist dd del details dfn div dl dt em
        fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
        html i iframe ins kbd label legend li map mark menu meter nav noscript object
        ol optgroup option output p pre progress q rp rt ruby s samp script section
        select small span strong style sub summary sup table tbody td textarea tfoot
        th thead time title tr u ul video"

tags = tags.split r/\s/g

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
    eval("with(dsl) { #(pogo.compile(template)) };")

render (tree) as html =
    if ((tree) is a string)
        tree
    else
        contents = tree.children.map @(child) @{ render (child) as html }
        "<#(tree.name)#(render (tree) attributes)>#(contents.join(''))</#(tree.name)>"

render template as html (path, locals) =
    template = fs.read file sync (path, 'utf-8')
    tree = evaluate (template) with (locals)
    render (tree) as html

render (object) attributes =
    str = ""
    for @(attr) in (object.attrs)
        str = str + ' ' + attr + '="' + object.attrs.(attr) + '"'
    
    str

(object) is a string =
    typeof (object) == 'string'

module.exports = render template as html