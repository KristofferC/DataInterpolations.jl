function findRequiredIdxs(A::QuadraticInterpolation, t)
  idxs = sortperm(A.t,by=x->abs(t-x))
  return idxs[1], idxs[2], idxs[3]
end

function findRequiredIdxs(A::LagrangeInterpolation, t)
  idxs = sortperm(A.t,by=x->abs(t-x))
  idxs[1:(A.n+1)]
end

function compute_splines(A::BSpline, t)
  n = length(A.t)
  d,k = A.d,A.k
  B = zero(A.t)
  if t == k[1]
    B[1] = one(A.t[1])
  elseif t == k[end]
    B[end] = one(A.t[1])
  else
    i = findfirst(x->x>t,A.k) - 1
    B[i] = one(A.t[1])
    for deg = 1:d
      B[i-deg] = (k[i+1]-t)/(k[i+1]-k[i-deg+1]) * B[i-deg+1]
      for j = (i-deg+1):(i-1)
        B[j] = (t-k[j])/(k[j+deg]-k[j]) * B[j] + (k[j+deg+1]-t)/(k[j+deg+1]-k[j+1]) * B[j+1]
      end
      B[i] = (t-k[i])/(k[i+deg]-k[i]) * B[i]
    end
  end
  B
end

function weibull_fun(x,p)
  ans = copy(x)
  for i = 1:length(x)
    if x[i] >= 0
      ans[i] = p[1] * (1 - exp(-1 * (x[i]/p[2])^p[3]))
    else
      ans[i] = 0.0
    end
  end
  ans
end