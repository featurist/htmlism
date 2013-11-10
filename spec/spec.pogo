htmlism = require '../src/htmlism'
fs = require 'fs'

describe 'htmlism'

    template = fs.read file sync ("#(__dirname)/example.pogo", 'utf-8')

    html = htmlism.render (template, { page title = "pogo ftw" })

    it 'makes html from a template'
        html.should.match r/<html>.*<head>.*<\/head>.*<\/html>/g

    it 'renders a tree of function calls as elements'
         html.should.match r/<h1>.+<\/h1>/g

    it 'renders the first argument to any element as attributes'
        html.should.include '<body id="super" class="happy days">'

    it 'binds an object as local variables'
        html.should.include "<title>pogo ftw</title>"
        html.should.include "<h1>pogo ftw</h1>"