export is_anagram, anagram_graph


"""
    is_anagram(w1,w2)
Checks if words `w1` and `w2` are anagrams of each other. 

All letters are reduced to lower case so `Act` and `cat` are
considered anagrams. 
"""
function is_anagram(w1::String, w2::String)::Bool
    c1 = counter(collect(lowercase(w1)))
    c2 = counter(collect(lowercase(w2)))
    return c1 == c2
end

"""
    anagram_graph(S, len=0, trim=0)
Create a graph whose vertices are words in `S` of length `len` in which two words are 
adjacent if they are anagrams of each other.  If `len` is zero, all words are used.
If `trim` is true, vertices of degree zero are removed.

Note that every component of this graph is a clique.
"""
function anagram_graph(S::Set{String}, len::Int = 0, trim::Bool = true)::SimpleGraph{String}
    G = _bare_graph(S, len)

    # add edges
    VV = vlist(G)
    n = NV(G)

    for i = 1:n-1
        w1 = VV[i]
        for j = i+1:n
            w2 = VV[j]
            if is_anagram(w1, w2)
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
        name(G, "Anagram Graph on all words")
    else
        name(G, "Anagram Graph on $len-letter words")
    end

    return G

end
