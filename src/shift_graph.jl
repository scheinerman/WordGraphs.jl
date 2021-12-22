export shift_graph

"""
    shift_graph(S::Set{String}, len::Int = 0, trim::Bool = false)
Create a word shift graph. For example, *stranger* and *estrange* are 
adjacent.

We use only words of length `len`, unless this is set to `0`
in which case all words are used.

If `trim` is set to `true` then vertices of degree zero are deleted.
"""
function shift_graph(S::Set{String}, len::Int = 0, trim::Bool = false)::SimpleGraph{String}

    G = _bare_graph(S, len)

    # for v in G.V
    #     add!(G, v)
    # end

    PM = Progress(NV(G))
    for w in G.V
        next!(PM)
        tail = w[2:end]
        for c in _A2Z
            ww = tail * c
            if has(G, ww)
                add!(G, w, ww)
            end
        end
    end

    # remove vertices of degree zero (if trim is true)
    if trim
        for w in G.V
            if deg(G, w) == 0
                delete!(G, w)
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
