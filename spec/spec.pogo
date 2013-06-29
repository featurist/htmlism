htmlism = require '../src/htmlism'

describe 'htmlism'
    
    options = { page title = "pogo ftw" }
    html = htmlism "./spec/example.pogo" (options)
    
    it 'makes html from a template'
        html.should.include "<html>"
        html.should.include "</html>"

    it 'renders a tree of function calls as elements'
        html.should.include "<h1>"
        html.should.include "</h1>"
        
    it 'renders the first argument to any element as attributes'
        html.should.include 'id="pogo"'
        html.should.include 'class="ok then"'
    
    it 'binds an object as local variables'
        html.should.include "<title>pogo ftw</title>"
        html.should.include "<h1>pogo ftw</h1>"