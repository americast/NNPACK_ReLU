using Flux
using BenchmarkTools, Compat 
using Suppressor

out = 1

@suppress_err begin
	for i in 1:10
		@show i
		global out
		a = collect(Cfloat, -2:10^i)
		b = copy(a)
		println("NNPACK:")
		@btime ccall((:nnp_relu__scalar,"libhere"),Void,(Ptr{Cfloat},Ptr{Cfloat},Csize_t, Cfloat), $a, $b,Csize_t(3 + 10^ $i),Cfloat(0))
		out = copy(a)
		println("Flux:")
		@btime begin
			global out
			out = Flux.relu($a)
		end
		# println(b)
		# println(out)
		println(out==b,"\n")
	end
end