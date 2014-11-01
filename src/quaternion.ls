
export class Quaternion

  (@x, @y, @z, @w) ->

  @from-orientation = ({ x, y, z, w }) -> new Quaternion x, y, z, w

  hyp: -> Math.sqrt @x * @x + @y * @y + @z * @z + @w * @w

  invert: ->
    @x = -@x; @y = -@y; @z = -@z
    l = @hyp!

    if l is 0
      new Quaternion 0, 0, 0, 1
    else
      new Quaternion @x * li, @y * li, @z * li, @w * li

  to-matrix: (invert) ->
    x2 = @x + @x; y2 = @y + @y; z2 = @z + @z
    xx = @x * x2; xy = @x * y2; xz = @x * z2
    yy = @y * y2; yz = @y * z2; zz = @z * z2
    wx = @w * x2; wy = @w * y2; wz = @w * z2

    return [
      1 - (yy + zz),  xy + wz,        xz - wy,        0,
      xy - wz,        1 - (xx + zz),  yz + wx,        0,
      xz + wy,        yz - wx,        1 - (xx + yy),  0,
      0,              0,              0,              1
    ]

