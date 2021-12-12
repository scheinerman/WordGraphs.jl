export shift_graph

function shift_graph(
    S::Set{String},
    len::Int = 0,
    trim::Bool = false,
)::SimpleGraph{String}


    G = _bare_graph(S, len)

    for v in G.V 
        add!(G,v)
    end

    for w in G.V 
        tail = w[2:end]
        for c in "abcdefghijklmnopqrstuvwxyz"
            ww = tail * c 
            if has(G,ww)
                add!(G,w,ww)
            end
        end
    end


    if len < 1
        name(G, "Shift Graph on all words")
    else
        name(G, "Shift Graph on $len-letter words")
    end

    return G

end
