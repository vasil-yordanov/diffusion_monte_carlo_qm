clear;
n=1;
d=3;
N0=10000;
x=20*rand(n*d,N0)-10;
E_R=0;
T=200;
dt_scalar=0.05;
N_T=T/dt_scalar;
dt=ones(N_T,1)*dt_scalar;
figure(2);
for i=1:N_T
    N=size(x,2);
    x = x+sqrt(dt(i))*randn(3,N);
    V = -1./sqrt(sum(x.^2));
    rc=-3/(2*(-log(N0+1)/dt(i)+E_R));
    Vrc=-2./(3*rc);
    V(rc>sqrt(sum(x.^2))) = Vrc;

    fprintf('avg energy: %f\n',sum(V)/N);
    P = exp( -( V - E_R )*dt(i));
    d_idx = (V > E_R) & 1 - P > rand(1,N);
    fprintf('will kill %d\n', sum(d_idx));
    % kill
    x(:,d_idx) = [];
    V(d_idx) = [];
    P(d_idx) = [];
    fprintf('after kill, avg energy: %f, E_R=%f\n',sum(V)/N, E_R);
        
    N=size(x,2);
    m = fix(P - 1 + rand(1,N));
    b_idx = V < E_R;
    % born
    fprintf('will born: %d\n',sum(b_idx .* m)); 
    if (sum(b_idx .* m) > 10000) 
        return;
    end
    x=repelem(x, 1, b_idx .* m + 1);
    N = size(x,2)
    fprintf('after born, avg energy: %f\n',sum(V)/N);
    if N == 0
        return;
    end
    V_avg = sum(V)/N;
    E_R = V_avg-(N-N0)/(N0*dt(i));
        
    plot(i,E_R,'ro');
    hold on;
    xlim([0 N_T]);
    ylim([-1 0]);
end
