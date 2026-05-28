using JuMP

nx = 400
ny = 400
b_val = 10
e = 0.1

hx = 2*pi/(nx+1)
hy = 2*b_val/(ny+1)

wq = Dict(i => (1 + e*cos(i*hx))^3 for i in 0:nx+1)

model = Model()

@variable(model, v[0:nx+1, 0:ny+1] >= 0)

@objective(model, Min,
    0.5*(hx*hy/6)*sum(
        (wq[i] + 2*wq[i+1])*(((v[i+1,j]-v[i,j])/hx)^2 + ((v[i,j+1]-v[i,j])/hy)^2)
        for i in 0:nx, j in 0:ny
    ) +
    0.5*(hx*hy/6)*sum(
        (2*wq[i] + 2*wq[i-1])*(((v[i-1,j]-v[i,j])/hx)^2 + ((v[i,j-1]-v[i,j])/hy)^2)
        for i in 1:nx+1, j in 1:ny+1
    ) -
    hx*hy*sum(e*sin(i*hx)*v[i,j] for i in 0:nx+1, j in 0:ny+1)
)

@constraint(model, c1[i in 0:nx+1], v[i,0] == 0)
@constraint(model, c2[i in 0:nx+1], v[i,ny+1] == 0)
@constraint(model, c3[j in 0:ny+1], v[0,j] == 0)
@constraint(model, c4[j in 0:ny+1], v[nx+1,j] == 0)

for i in 0:nx+1
    for j in 0:ny+1
        set_start_value(v[i,j], max(sin(i*hx), 0.0))
    end
end
