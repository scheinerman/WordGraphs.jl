export ladder_graph


"""
    ladder_adj(w1, w2)
return true if words `w1` and `w2` have the same length
and differ in exactly one location.
"""
function ladder_adj(w1::String, w2::String)::Bool
    if length(w1) != length(w2)
        return false
    end
    c = collect(w1) .!= collect(w2)
    return sum(c) == 1
end

"""
    ladder_graph(S::Set{String}, len::Int=0, trim::Bool=false)

Create a graph whose vertices are words in which two words are adjacent if they differ
in exactly one letter. 

We use only words of length `len`, unless this is set to `0`
in which case all words are used.

If `trim` is set to `true` then vertices of degree zero are deleted.
"""
function ladder_graph(S::Set{String}, len::Int = 0, trim::Bool = false)::SimpleGraph{String}
    G = _bare_graph(S, len)

    VV = vlist(G)
    n = NV(G)
    for i = 1:n-1
        w1 = VV[i]
        for j = i+1:n
            w2 = VV[j]
            if ladder_adj(w1, w2)
                add!(G, w1, w2)
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
        name(G, "Ladder Graph on all words")
    else
        name(G, "Ladder Graph on $len-letter words")
    end

    return G




end
