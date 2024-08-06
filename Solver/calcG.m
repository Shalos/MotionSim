function [ gmat ] = calcG( e )
      %calculate the skew of e1, e2, e3
     %calculate the 2nd half of g
    gmat = [-e(2:4), Skew(e(2:4)) + e(1)*eye([3 3]) ];          %put together the g matrix
end

