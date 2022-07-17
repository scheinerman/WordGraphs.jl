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


function make_anagrams(word::String)::Vector{String}
    anags = unique(collect(permutations(word)))
    return join.(anags)
end


"""
    anagram_graph(S, len=0, trim=false)
Create a graph whose vertices are words in `S` of length `len` in which two words are 
adjacent if they are anagrams of each other.  If `len` is zero, all words are used.
If `trim` is true, vertices of degree zero are removed.

Note that every component of this graph is a clique.
"""
function anagram_graph(
    S::Set{String},
    len::Int = 0,
    trim::Bool = false,
)::UG{String}
    G = _bare_graph(S, len)

    # add edges

    VV = deepcopy(G.V)
    n = NV(G)
    PM = Progress(n)

    while length(VV) > 0
        next!(PM)
        v = first(VV)
        anas = [ana for ana ∈ make_anagrams(v) if ana ∈ G.V]
        nana = length(anas)
        for i = 1:nana-1
            for j = i+1:nana
                add!(G, anas[i], anas[j])
            end
            next!(PM)
        end
        for a in anas
            delete!(VV, a)
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
