htmlism = require '../src/htmlism'

describe 'htmlism'
    
    options = { page title = "pogo ftw" }
    html = htmlism.render file "./spec/example.pogo" (options)
    
    it 'makes html from a template'
        html.should.match r/<html>.*<head>.*<\/head>.*<\/html>/g

    it 'renders a tree of function calls as elements'
         html.should.match r/<h1>.+<\/h1>/g
        
    it 'renders the first argument to any element as attributes'
        html.should.include '<body id="pogo" class="happy days">'
    
    it 'binds an object as local variables'
        html.should.include "<title>pogo ftw</title>"
        html.should.include "<h1>pogo ftw</h1>"