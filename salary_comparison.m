employeeData =  webread('https://demo.slashdb.com/db/pystreet/response/empl_type/Employee.json');
selfEmployedData =  webread('https://demo.slashdb.com/db/pystreet/response/empl_type/Self-employed.json');
exchangeRates = webread('https://demo.slashdb.com/db/pystreet/exch_rate.json');

employeeUsdSal = zeros(1,123);
selfEmployedUsdSal = zeros(1,33);

employeeSalary = [employeeData.salary];
employeeCcy = {employeeData.ccy};
employeeCountry = {employeeData.country};

selfEmployedSalary = [selfEmployedData.salary];
selfEmployedCcy = {selfEmployedData.ccy};
selfEmployedCountry = {selfEmployedData.country};

exchRateCcy = {exchangeRates.ccy};
exchRate = [exchangeRates.rate];

for i=1:length(employeeSalary)
  j = find(ismember(exchRateCcy, employeeCcy(i)));
  employeeUsdSal(i) = employeeSalary(i) / exchRate(j);
end

for i=1:length(selfEmployedSalary)
  j = find(ismember(exchRateCcy, selfEmployedCcy(i)));
  selfEmployedUsdSal(i) = selfEmployedSalary(i) / exchRate(j);
end

employeeEurSal = zeros(1,123);
selfEmployedEurSal = zeros(1,33);

employeeInrSal = zeros(1,123);
selfEmployedInrSal = zeros(1,33);

for i=1:length(employeeSalary)
  j = find(ismember(exchRateCcy, 'EUR'));
  k = find(ismember(exchRateCcy, 'INR'));
  employeeEurSal(i) = employeeUsdSal(i) * exchRate(j);
  employeeInrSal(i) = employeeUsdSal(i) * exchRate(k);
end

for i=1:length(selfEmployedSalary)
  j = find(ismember(exchRateCcy, 'EUR'));
  k = find(ismember(exchRateCcy, 'INR'));
  selfEmployedEurSal(i) = selfEmployedUsdSal(i) * exchRate(j);
  selfEmployedInrSal(i) = selfEmployedUsdSal(i) * exchRate(k);
end

employeeCountries = unique(employeeCountry);
selfEmployedCountries = unique(selfEmployedCountry);

highestEmployeeSalUsd = zeros(1,33);
highestEmployeeSalEur = zeros(1,33);
highestEmployeeSalInr = zeros(1,33);

highestSelfEmployedSalUsd = zeros(1,15);
highestSelfEmployedSalEur = zeros(1,15);
highestSelfEmployedSalInr = zeros(1,15);

for i=1:length(employeeCountries)
  currEmpCounInds = find(ismember(employeeCountry,     employeeCountries(i)));
  
  currEmpUsd = sort(employeeUsdSal(currEmpCounInds),'descend');
  currEmpEur = sort(employeeEurSal(currEmpCounInds),'descend');
  currEmpInr = sort(employeeInrSal(currEmpCounInds),'descend');
  
  highestEmployeeSalUsd(i) = currEmpUsd(1);
  highestEmployeeSalEur(i) = currEmpEur(1);
  highestEmployeeSalInr(i) = currEmpInr(1);
end

for i=1:length(selfEmployedCountries)
  currSelfEmpCounInds = find(ismember(selfEmployedCountry, selfEmployedCountries(i)));
  
  currSelfEmpUsd = sort(selfEmployedUsdSal(currSelfEmpCounInds),'descend');
  currSelfEmpEur = sort(selfEmployedEurSal(currSelfEmpCounInds),'descend');
  currSelfEmpInr = sort(selfEmployedInrSal(currSelfEmpCounInds),'descend');
  
  highestSelfEmployedSalUsd(i) = currSelfEmpUsd(1);
  highestSelfEmployedSalEur(i) = currSelfEmpEur(1);
  highestSelfEmployedSalInr(i) = currSelfEmpInr(1);
end

empX = categorical(employeeCountries);
selfEmpX = categorical(selfEmployedCountries);

bar(empX, highestEmployeeSalUsd)
bar(empX, highestEmployeeSalEur)
bar(empX, highestEmployeeSalInr)

bar(selfEmpX, highestSelfEmployedSalUsd)
bar(selfEmpX, highestSelfEmployedSalEur)
bar(selfEmpX, highestSelfEmployedSalInr)