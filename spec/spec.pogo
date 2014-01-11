htmlism = require '../src/htmlism'
fs = require 'fs'
cheerio = require 'cheerio'

describe 'htmlism'

    template = fs.read file sync ("#(__dirname)/example.pogo", 'utf-8')

    describe '.render()'

        html = htmlism.render (template, { page title = "pogo ftw", numbers = [1, 2, 3] })

        $ = cheerio.load(html)

        it 'makes html from a template'
            $('body h1').length.should.equal 1

        it 'renders the first argument to any element as attributes'
            $('body#super.happy.days').length.should.equal 1

        it 'binds local variables represented as an object'
            $('title').text().should.equal 'pogo ftw'
            $('h1').text().should.equal 'pogo ftw'

        it 'renders numbers as strings'
            $('#numbers p').eq(2).text().should.equal('3')

    describe '.evaluate(template, locals)'

        it 'creates a tree'

            html = htmlism.evaluate (template, { page title = "zomg", numbers = [9, 8, 7] })
            html.should.eql {
                name = 'html'
                attrs = {}
                children = [
                    {
                        name = 'head'
                        attrs = {}
                        children = [
                            { name = 'title', attrs = {}, children = [ 'zomg' ] }
                        ]
                    }
                    {
                        name = 'body'
                        attrs = { id = 'super', class = 'happy days' }
                        children = [
                            { name = 'h1', attrs = {}, children = [ 'zomg' ] }
                            { name = 'p',  attrs = {}, children = [ 'Hello, pogo!' ] }
                            {
                                name = 'div'
                                attrs = { id = 'numbers' }
                                children = [
                                    { name = 'p', attrs = {}, children = [ '9' ] }
                                    { name = 'p', attrs = {}, children = [ '8' ] }
                                    { name = 'p', attrs = {}, children = [ '7' ] }
                                ]
                            }
                        ]
                    }
                ]
            }
