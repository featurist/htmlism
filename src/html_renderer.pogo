render (tree) =
    if (tree :: String)
        tree
    else
        contents = tree.children.map @(child) @{ render (child) }
        "<#(tree.name)#(render (tree) attributes)>#(contents.join(''))</#(tree.name)>"

render (object) attributes =
    str = ""
    for @(attr) in (object.attrs)
        str := [str, ' ', attr, '="', object.attrs.(attr), '"'].join ''

    str

module.exports = render