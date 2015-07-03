lambdas = [480, 520, 680, 520, 520, 680]';
NAs = [.5, .5, .5, 1, 1.4, 1.5]';
colors = ['y', 'm', 'c', 'r', 'g', 'b'];
legendStrs = {};

for i = 1:numel(lambdas)
    
    lambda = lambdas(i);
    NA = NAs(i);
    legendStr = ['Lambda = ' num2str(lambda) ', NA = ' num2str(NA)];
    legendStrs{1, i} = legendStr;
    [ I , sp] = airyDisk( lambda, NA );
    plot(sp, I, colors(i));
    hold on;    
    legend(legendStrs);
end



% Testing airyPattern function

r = -10:.1:10;
h = airyPattern(r);
figure,plot(r,h);
