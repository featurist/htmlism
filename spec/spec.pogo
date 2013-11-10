htmlism = require '../src/htmlism'
fs = require 'fs'
cheerio = require 'cheerio'

describe 'htmlism'

    template = fs.read file sync ("#(__dirname)/example.pogo", 'utf-8')

    html = htmlism.render (template, { page title = "pogo ftw" })

    $ = cheerio.load(html)

    it 'makes html from a template'
        $('body h1').length.should.equal 1

    it 'renders the first argument to any element as attributes'
        $('body#super.happy.days').length.should.equal 1

    it 'binds local variables represented as an object'
        $('title').text().should.equal 'pogo ftw'
        $('h1').text().should.equal 'pogo ftw'
