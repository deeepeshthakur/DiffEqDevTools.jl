using NLsolve
"""
`Base.length(tab::ODERKTableau)`

Defines the length of a Runge-Kutta method to be the number of stages.
"""
Base.length(tab::ODERKTableau) = tab.stages

"""
`stability_region(z,tab::ODERKTableau)`

Calculates the stability function from the tableau at `z`. Stable if <1.

```math
r(z) = \\frac{\\det(I-zA+zeb^T)}{\\det(I-zA)}
```
"""
stability_region(z,tab::ODERKTableau) = det(eye(tab.stages)- z*tab.A + z*ones(tab.stages)*tab.α')/det(eye(tab.stages)-z*tab.A)

"""
`stability_region(tab::ODERKTableau)`

Calculates the length of the stability region in the real axis.
"""
function stability_region(tab::ODERKTableau; initial_guess=-3.0)
  residual! = function (resid, x)
    resid[1] = abs(stability_region(x[1], tab)) - 1
  end
  sol = nlsolve(residual!, [initial_guess])
  sol.zero[1]
end
