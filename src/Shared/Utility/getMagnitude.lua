local function getMagnitude(v1: Vector3, v2: Vector3)
    return (v1 - v2).Magnitude
end

return getMagnitude