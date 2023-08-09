% Verilerin okunması ve hazırlanması 
data = readmatrix('denemenew444.csv'); % 'denemenew444.csv' adlı veri dosyası 
okunuyor. 
data % Veriler ekrana yazdırılıyor. 
% Veri görselleştirme 
figure; % Yeni bir grafik penceresi oluşturuluyor. 
plot(data) % Verilerin grafiği çizdiriliyor. 
% Eğitim ve test veri setlerinin hazırlanması 
num_steps_train = floor(.9 * numel(data)); % Eğitim veri setinin boyutu 
belirleniyor. 
train = data(1:num_steps_train + 1); % Eğitim veri seti oluşturuluyor. 
test = data(num_steps_train + 1:end); % Test veri seti oluşturuluyor. 
% Eğitim verilerinin standartlaştırılması 
mu = mean(train); % Eğitim verilerinin ortalaması hesaplanıyor. 
sigma = std(train); % Eğitim verilerinin standart sapması hesaplanıyor. 
std_train_data = (train - mu) / sigma; % Eğitim verileri standartlaştırılıyor. 
std_train_data % Standartlaştırılmış eğitim verileri ekrana yazdırılıyor. 
% Sinir ağı modeli için katmanların tanımlanması 
num_features = 1; % Girdi özellik sayısı (bir zaman adımı için sadece bir özellik 
kullanıldığı varsayılıyor). 
num_responses = 1; % Çıktı sayısı (bir zaman adımı için sadece bir çıktı 
kullanıldığı varsayılıyor). 
num_hidden_units = 200; % LSTM katmanındaki gizli birim sayısı belirleniyor. 
layers = [sequenceInputLayer(num_features) 
lstmLayer(num_hidden_units) 
fullyConnectedLayer(num_responses) 
regressionLayer]; % LSTM tabanlı regresyon modelinin katmanları 
tanımlanıyor. 
layers % Katmanlar ekrana yazdırılıyor. 
% Eğitim seçeneklerinin belirlenmesi 
options = trainingOptions('adam', ... 
'MaxEpochs', 250, ... 
'GradientThreshold', 1, ... 
'InitialLearnRate', 0.005, ... 
'LearnRateSchedule', 'piecewise', ... 
'LearnRateDropPeriod', 125, ... 
'LearnRateDropFactor', 0.2, ... 
'Verbose', 0, ... 
'Plots', 'training-progress'); % Eğitim seçenekleri belirleniyor. 
options % Seçenekler ekrana yazdırılıyor. 
% Sinir ağı modelinin eğitilmesi 
net = trainNetwork(xtrain, ytrain, layers, options); % Sinir ağı modeli 
eğitiliyor. 
% Test verilerinin standartlaştırılması ve tahminlerin yapılması 
std_test_data=(test-mu)/sigma; % Test verileri standartlaştırılıyor. 
xtest=std_test_data(1:end-1); % Test verilerinin girişleri (x) oluşturuluyor. 
net=predictAndUpdateState(net,xtrain); % Eğitim verileri kullanılarak sinir ağı 
modelinin durumu güncelleniyor. 
[net,ypred]=predictAndUpdateState(net,ytrain(end)); % Son eğitim verisine dayalı 
tahminler yapılıyor. 
num_steps_test = numel(xtest); % Test veri setinin boyutu belirleniyor. 
for i = 2:num_steps_test 
[net, ypred(:, i)] = predictAndUpdateState(net, ypred(:, i - 1)); % Tahminler 
yapılırken modelin durumu güncelleniyor. 
end 
% Tahminlerin orijinal ölçeklere dönüştürülmesi ve RMSE hesaplanması 
ypred = ypred * sigma + mu; % Standartlaştırılmış tahminlerin orijinal ölçeklere 
dönüştürülmesi. 
ytest = test(2:end); % Test veri setindeki gerçek değerler (çıktılar) alınıyor. 
rmse = sqrt(mean((ypred - ytest).^2)); % Kök Ortalama Kare Hatası (RMSE) 
hesaplanıyor. 
rmse % RMSE değeri ekrana yazdırılıyor. 
% Eğitim verileri ve tahminlerin görselleştirilmesi 
plot(train(1:end - 1)); % Eğitim verilerinin grafiği çizdiriliyor. 
hold on 
idx = num_steps_train:(num_steps_train + num_steps_test); 
plot(idx, [data(num_steps_train), ypred], '.-'); % Tahminlerin grafiği 
çizdiriliyor. 
legend(["Gözlemlenen" "Tahmin Edilen"]) % Grafiğin açıklaması belirtiliyor. 
figure 
% Gerçek ve tahmin edilen değerlerin grafik üzerinde görselleştirilmesi 
subplot(2, 1, 1) 
plot(ytest) 
hold on 
plot(ypred, '.-') 
hold off 
legend(["Gözlemlenen" "Tahmin Edilen"]) 
subplot(2, 1, 2) 
stem(ypred - ytest) 
ylabel("Hata") 
title("RMSE = " + rmse) 
% Sinir ağı sıfırlama ve güncellenmiş tahminlerin yapılması 
net = resetState(net); % Sinir ağı sıfırlanıyor. 
net = predictAndUpdateState(net, xtrain); % Eğitim verileri kullanılarak modelin 
durumu güncelleniyor. 
ypred = []; % Güncellenmiş tahminlerin saklanacağı boş bir dizi oluşturuluyor. 
for i = 1:num_steps_test 
[net, ypred(:, i)] = predictAndUpdateState(net, xtest(:, i)); % Güncellenmiş 
tahminler yapılıyor. 
end 
% Tahminlerin orijinal ölçeklere dönüştürülmesi ve RMSE hesaplanması 
ypred = sigma * ypred + mu; % Standartlaştırılmış tahminlerin orijinal ölçeklere 
dönüştürülmesi. 
rmse = sqrt(mean((ypred - ytest).^2)); % Kök Ort 
figure 
subplot(2,1,1) 
plot(ytest) 
hold on 
plot(ypred,'.-') 
hold off 
legend(["observed" "forecast"]) 
ylabel ("cases") 
xlabel("Month") 
title("Forecast with updates") 
subplot(2,1,2) 
stem(ypred-ytest) 
ylabel("error") 
xlabel("mont") 
title("rmse="+rmse) 