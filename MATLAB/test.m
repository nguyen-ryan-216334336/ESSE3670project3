function [x] = test()

x = [1, 2, 3, 4, 5];
y = [2, 3, 3, 3, 3];

data = [x;y];
figure('Position', [50 50 1000 600])
for i = 1:
plot(x);

end