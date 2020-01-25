# segment types
"""
Finite set {0, .., k-1}
"""
struct Segment{T} <: AbstractSegment
    itr :: UnitRange{T}
end


"""
Finite set {c, .., c + k-1}
"""
struct ShiftedSegment{T} <: AbstractSegment
    itr :: UnitRange{T}
end


# Segment initializers

"""
Construct a Segment [0..k-1]
"""
Segment(k :: Int) = Segment(0 : (k-1))

"""
Construct a Segment [start..finish]
"""
Segment(start, finish) = ShiftedSegment(start : finish)



# INTERFACE FUNCTIONS
iterator(s :: Segment) = s.itr