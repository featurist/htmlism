html
    head
        title (page title)

    body { id = 'super', class = 'happy days' }
        h1
            page title

        awesome = "pogo"

        p "Hello, #(awesome)!"

        div { id = 'numbers' }

            for each @(num) in (numbers)
                p (num)