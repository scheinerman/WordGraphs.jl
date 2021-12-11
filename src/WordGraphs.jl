module WordGraphs

using SimpleGraphs, Counters

export make_word_set

"""
    make_word_set
Returns a set of words read in from a file. 

Optional named arguments:
* `file_name` specifies the word list to use. Default is `/usr/share/dict/words`.
* `lower_case_only` specifies that only words comprised of lower case letters are used. Default is `true`.
"""
function make_word_set(;
    file_name::String = "/usr/share/dict/words",
    lower_case_only::Bool = true,
)::Set{String}
    F = open(file_name)
    words = readlines(F)
    if !lower_case_only
        return Set(words)
    end

    S = Set{String}()

    for w in words
        if any(isuppercase(c) for c in w)
            continue
        end
        push!(S, w)
    end
    return S
end

"""
    _bare_graph(S, len=0)
Create a word graph with no edges. The words are the elements of `S`
that have length `len`, unless `len==0` in which case all words are added.
"""
function _bare_graph(S::Set{String}, len::Int = 0)::SimpleGraph{String}
    G = StringGraph()
    # add words in S as vertices of the graph
    if len < 1     # add all words
        for w in S
            add!(G, w)
        end
    else           # add only words of length len
        for w in S
            if length(w) == len
                add!(G, w)
            end
        end
    end
    return G
end

include("anagram_graph.jl")
include("ladder_graph.jl")

end # module
