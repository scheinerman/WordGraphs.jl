# WordGraphs

This is a module for turning lists of words into graphs. Begin like this:
```julia
julia> using WordGraphs, SimpleGraphs
```

## Load a list of words

The function `make_word_set` reads in a list of words (a plain text file with one word per line)
and returns those words in a `Set`. On a Unix system (include Mac) one can use
`/usr/share/dict/words`.

The function takes two, optional named arguments:
* `file_name` specifies the file containing the word list. If omitted, use `"/usr/share/dict/words"`.
* `lower_case_only` specifies if words containing capital letters should be ignored. This is `true` by default. 

## Ladder graphs

A word ladder is a sequence of words in which one letter is changed at a time.
Create a ladder graph as follows: 
```julia
julia> words = make_word_set();

julia> G = ladder_graph(words, 5)
Ladder Graph on 5-letter words (n=8497, m=18326)
```

In general, the syntax is 
```julia
ladder_graph(S::Set{String}, len::Int=0, trim::Bool=false)
```
where
* `S` is the set of words (from `make_word_set`).
* `len` is the word length. Use `0` to include all words from `S` in the graph.
* `trim` is set to `true` to delete isolated vertices from the graph.

### Example

The `find_path` function from `SimpleGraphs` can now be used to solve word ladder
puzzles. For example, to change *mouse* to *zebra* we do this:
```julia
julia> find_path(G, "mouse", "zebra")
11-element Vector{String}:
 "mouse"
 "mousy"
 "mouly"
 "souly"
 "soury"
 "sorry"
 "sorra"
 "sarra"
 "sabra"
 "zabra"
 "zebra"
 ```


## Anagram graphs

In an anagram graph, there is an edge between two words if one is an anagram of the
other. Consequently, every component of the graph is a clique. The arguments are the same 
as for `ladder_graph`.
```julia
julia> Words = make_word_set();

julia> G = anagram_graph(Words, 4)
Anagram Graph on 4-letter words (n=4347, m=2041)

julia> G["stop"]
3-element Vector{String}:
 "post"
 "spot"
 "tops"
 ```
 This shows that the word *stop* has three anagrams: *post*, *spot*, and *tops*. 

## Combining

In this example, we combine a ladder graph with an anagram graph to find a 
path from *good* to *evil* that involves both letter substitutions and 
anagrams:
```julia
julia> G = anagram_graph(Words, 4)
Anagram Graph on 4-letter words (n=4347, m=2041)

julia> H = ladder_graph(Words, 4)
Ladder Graph on 4-letter words (n=4347, m=23507)

julia> GH = union(G,H)
SimpleGraph{String} (n=4347, m=25548)

julia> find_path(GH, "good", "evil")
7-element Vector{String}:
 "good"
 "food"
 "fold"
 "fole"
 "vole"
 "vile"
 "evil"
 ```

 ## To do

 Create a `shift_digraph` with edges of the form 
 `"abcd" → "bcde"`.
