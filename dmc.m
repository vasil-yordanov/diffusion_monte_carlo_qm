clear;
N0=100000;
x=20*rand(3,N0)-10;
E_R=0;
T=35;
dt_scalar=0.04;
N_T=fix(T/dt_scalar);
dt=ones(N_T,1)*dt_scalar;
figure(1);
N=N0;
for i=1:N_T
    % diffusion - random walk
    x = x+sqrt(dt(i))*randn(3,N);

    % calculate potential
    V = -1./sqrt(sum(x.^2));
    rc=-3/(2*(-log(N0+1)/dt(i)+E_R));
    Vrc=-2./(3*rc);
    V(rc>sqrt(sum(x.^2))) = Vrc;

    P = exp( -( V - E_R )*dt(i));
    
    % kill
    d_idx = (V > E_R) & 1 - P > rand(1,N);
    x(:,d_idx) = [];
    V(d_idx) = [];
    P(d_idx) = [];    
    N=size(x,2);
    
    % born
    m = fix(P - 1 + rand(1,N));
    b_idx = V < E_R;
    x=repelem(x, 1, b_idx .* m + 1);
    N = size(x,2);

    % calculate the new reference energy
    V_avg = sum(V)/N;
    E_R = V_avg-(N-N0)/(N0*dt(i));
    
    fprintf('V_avg: %.5f, E_R=%.5f, N=%5.0f\n', V_avg, E_R, N);
        
    plot(i, E_R, 'r.');
    hold on;
end

figure(2);
hist(sqrt(sum(x.^2)),100);

figure(3);
plot3(x(1,:), x(2,:), x(3,:),'.');
