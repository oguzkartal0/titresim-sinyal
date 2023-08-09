% Veri kümesi 
t = Times; 
x = LDZams2; 
% Gürültü ekleyelim 
rng(42); 
noise = 2 * randn(size(t)); 
x_noisy = x + noise; 
% Autoencoder modeli oluşturma 
hidden_size = 32; 
autoencoder = feedforwardnet(hidden_size); 
autoencoder.layers{end}.transferFcn = 'purelin';  % Çıkış katmanının aktivasyon 
fonksiyonunu lineer yapıyoruz 
% Modeli eğitme 
autoencoder = train(autoencoder, x_noisy', x'); 
% Temiz veri ve gürültülü veriyi elde etme 
x_clean = autoencoder(x_noisy'); 
x_noisy = autoencoder(x_noisy'); 
% Anormallik eşik değeri 
threshold = 1.5; % Eşik değerini deneyerek uygun bir değer seçebilirsiniz. 
% Anormallik hesaplama 
anomaly = abs(x - x_clean'); 
% Anormallik derecesi 4'ten büyük olanları bulma 
error_indices = find(anomaly > 5); 
error_times = t(error_indices); 
% Orijinal veri, temiz ve gürültülü veri grafiği 
figure; 
subplot(2, 1, 1); 
plot(t, x, 'b', 'LineWidth', 1.5); 
hold on; 
plot(t, x_clean, 'g', 'LineWidth', 1.5); 
plot(t, x_noisy, 'r', 'LineWidth', 1.5); 
xlabel('Zaman'); 
ylabel('Değerler'); 
legend('Orjinal Veri', '', 'Gürültülü Veri'); 
grid on; 
% Anormallik grafiği 
subplot(2, 1, 2); 
bar(t, anomaly, 'm'); 
hold on; 
plot(t, 4 * ones(size(t)), 'r--', 'LineWidth', 1.5); % Eşik değeri çizgisi 
xlabel('Zaman'); 
ylabel('Anormallik'); 
ylim([0, max(anomaly) + 0.5]); % Y ekseni sınırlarını ayarlayın 
grid on; 
% Pencere boyutunu ayarlama 
set(gcf, 'Position', [100, 100, 800, 600]); 
% Anormallik derecesi 4'ten büyük olanları ekrana yazdırma 
disp('Hata Tespiti Yapılan Zamanlar:'); 
disp(error_times);