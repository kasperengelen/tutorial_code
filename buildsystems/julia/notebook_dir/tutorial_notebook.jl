### A Pluto.jl notebook ###
# v0.20.1

using Markdown
using InteractiveUtils

# ╔═╡ 93b4d82b-0bb5-4fe1-b974-46dcda0de175
begin
    import Pkg
    Pkg.activate()
	using FunctionDiff
end

# ╔═╡ 25c70328-a213-11ef-398b-bda7049243e8
md"""
# Pluto tutorial
In this tutorial we will learn how to use a Pluto notebook.
"""

# ╔═╡ d19e9a2f-dacf-49e1-8acb-d97228aaa023
md"""We begin by importing our package."""

# ╔═╡ a81af648-af6a-45c0-9363-dce71d7043b3
md"""Next, we create our polynomial..."""

# ╔═╡ a86ebd90-af04-439e-9080-5b748411a800
polynom = FunctionDiff.getPolynomial([-0.5, -1.8, -1.7, 1.4, 1.3])

# ╔═╡ 4581e42b-094b-4cd7-99cc-3a6c9db6b2ec
md"""... and compute its derivative."""

# ╔═╡ 130bd32e-c1b2-452d-a352-ccd1b510701a
deriv = FunctionDiff.getDerivative(polynom)

# ╔═╡ 06cc3005-4584-4a3b-aab2-390326770c0a
md"""Finally, we plot both the polynomial and derivative."""

# ╔═╡ 49cdecb2-6c3c-47e5-b6f2-b3afe722aac9
FunctionDiff.plotFunction(polynom, deriv)

# ╔═╡ Cell order:
# ╟─25c70328-a213-11ef-398b-bda7049243e8
# ╟─d19e9a2f-dacf-49e1-8acb-d97228aaa023
# ╠═93b4d82b-0bb5-4fe1-b974-46dcda0de175
# ╟─a81af648-af6a-45c0-9363-dce71d7043b3
# ╠═a86ebd90-af04-439e-9080-5b748411a800
# ╟─4581e42b-094b-4cd7-99cc-3a6c9db6b2ec
# ╠═130bd32e-c1b2-452d-a352-ccd1b510701a
# ╟─06cc3005-4584-4a3b-aab2-390326770c0a
# ╠═49cdecb2-6c3c-47e5-b6f2-b3afe722aac9
