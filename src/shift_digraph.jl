export shift_digraph

function shift_digraph(
    S::Set{String},
    len::Int = 0,
    trim::Bool = false,
)::SimpleDigraph{String}


    G0 = WordGraphs._bare_graph(S, len)
    G = SimpleDigraph{String}()
    for v in G0.V 
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
    return G

end
