showNextExcerpt = () ->
    next_excerpt = $(".blog-excerpt.active").next();
    $(".blog-excerpt.active").removeClass("active");
    
    if (next_excerpt.is(".blog-excerpt"))
        $(next_excerpt).addClass("active");
    else
        $(".blog-excerpt").first().addClass("active");
        
init = () ->
    blog_excerpts = $(".blog-excerpt")
    console.log ("found #{blog_excerpts.length}")
    if (blog_excerpts.length > 0)
        $(blog_excerpts).first().addClass("active");

    console.log "doing next"

    $(".blog-excerpt-next-link").click showNextExcerpt
    
$(document).ready init

