function [volOverlapE] = calcMetrics(frame10mask, frame15mask, frame20mask, fr10,fr15, fr20)


vol10 = sum(frame10mask & fr10) / sum(frame10mask | fr10);

vol15 = sum(frame15mask & fr15) / sum(frame15mask | fr15);

vol20 = sum(frame20mask & fr20) / sum(frame15mask | fr20);

volOverlapE = (vol10+ vol15+ vol20)*100/3;

end

