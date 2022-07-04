function demise = change(ddd);

dgr=fix(ddd);
min=fix((ddd-dgr)*60);
sec=((ddd-dgr)*60-min)*60;
demise=[dgr min sec]

%save('azymut.mat');
