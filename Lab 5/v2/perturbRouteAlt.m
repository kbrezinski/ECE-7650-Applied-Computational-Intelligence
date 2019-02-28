function [theCityRoute] = perturbRouteAlt(numCities, theCityRoute)

D=zeros(npts,npts);
for q1=1:npts
    D(q1,:)=sqrt((Xin(q1)-Xin).^2+(Yin(q1)-Yin).^2);
end

%max distance
maxD=max(D(:));

end