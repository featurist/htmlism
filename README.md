# Htmlism

A little template engine for [PogoScript](http://pogoscript.org/).

Given some HTML, pogo style:

    html

        body { class = 'important' }

            p (message)

Running it through htmlism like this:

     htmlism.render '<the-template-above>' { message = 'hello world' }

Renders this string:

    <html><body class="important"><p>hello world</p></body></html>

# This is just for fun.

Of course, I don't mean for anybody to _actually_ use this!