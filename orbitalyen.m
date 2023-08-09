% X ve Z koordinatları dizileri (örneğin, bu verileri sizin sağlamanız gerekecektir)
x = LDZams2; % X koordinatları
z = LDXams2; % Z koordinatları

% Yörünge çizimi için 2D grafik penceresi açın
figure;
plot(x, z, 'b', 'LineWidth', 2);
grid on;
xlabel('X Koordinatı');
ylabel('Z Koordinatı');
title('2 Boyutlu Orbital');
% X ve Z koordinatları dizileri (örneğin, bu verileri sizin sağlamanız gerekecektir)
x = LDZams2; % X koordinatları
z = LDXams2; % Z koordinatları
% X ve Z koordinatları dizileri (örneğin, bu verileri sizin sağlamanız gerekecektir)
x = LDZams2; % X koordinatları
z = LDXams2; % Z koordinatları

% Verilerdeki NaN veya infinite değerleri temizleyin
x_cleaned = x(isfinite(x));
z_cleaned = z(isfinite(z));

% Filtreleme için parametreleri belirleyin
order = 4; % Filtre sırası (4 genellikle iyi sonuçlar verir)
cutoff_freq = 0.2; % Kesme frekansı (0 ile 1 arasında bir değer belirleyin)
% Örnekleme periyodu (örneğin, 1 saniyede 100 örnek alındıysa Ts = 0.01)
Ts = 2;

% Butterworth filtre katsayılarını hesaplayın
[b, a] = butter(order, cutoff_freq / (1 / (2 * Ts)));

% X ve Z koordinatlarını Butterworth filtresiyle filtreleyin
x_filtered = filtfilt(b, a, x_cleaned);
z_filtered = filtfilt(b, a, z_cleaned);

% Yörünge verilerini interpolasyon yaparak düzeltin
num_points = 1000; % Daha düzgün bir yörünge için nokta sayısı artırılabilir
x_interp = interp1(x_filtered, linspace(1, numel(x_filtered), num_points), 'pchip');
z_interp = interp1(z_filtered, linspace(1, numel(z_filtered), num_points), 'pchip');

% Orbit çizimi için 2D grafik penceresi açın
figure;
plot(x_interp, z_interp, 'b', 'LineWidth', 2);
axis equal; % Eksenleri eşit ölçekte tutmak için
grid on;
xlabel('X Koordinatı');
ylabel('Z Koordinatı');
title('Filtrelenmiş Orbital');

