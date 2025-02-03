#Membuat tabel baru bernama 'analisa' di dataset 'Rakamin_KF_Analytics
CREATE TABLE `task-5-pbi-iqbal-kamal.Rakamin_KF_Analytics.analisa` AS

#Memilih kolom-kolom yang akan dimasukkan ke dalam tabel analisa
SELECT 
    transaction_id,
    date,
    branch_id,
    kota,
    provinsi,
    rating_cabang,
    customer_name,
    product_id,
    product_name,
    actual_price,
    discount_percentage,
    persentase_gross_laba,
    nett_sales, 
    #Menghitung laba bersih (nett_profit)
    (actual_price * persentase_gross_laba) - (actual_price - nett_sales) AS nett_profit,
    rating_transaksi

#Mengambil data dari beberapa tabel yang digabungkan
FROM (
    SELECT 
        ft.transaction_id,
        ft.date,
        kc.branch_id,
        kc.kota,
        kc.provinsi,
        kc.rating AS rating_cabang,
        ft.customer_name,
        p.product_id,
        p.product_name,
        p.price AS actual_price,
        ft.discount_percentage,
#Menggunakan CASE statement untuk menentukan persentase laba berdasarkan harga produk
        CASE
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            WHEN p.price > 500000 THEN 0.30
        END AS persentase_gross_laba,
        #Menghitung nett_sales (penjualan bersih) setelah diskon diterapkan
        p.price * (1 - ft.discount_percentage) AS nett_sales,
        ft.rating AS rating_transaksi
    FROM Rakamin_KF_Analytics.kf_final_transaction AS ft
    #Menggabungkan tabel transaksi dengan tabel cabang berdasarkan branch_id
    INNER JOIN Rakamin_KF_Analytics.kf_kantor_cabang AS kc
        ON ft.branch_id = kc.branch_id
    #Menggabungkan tabel transaksi dengan tabel produk berdasarkan product_id
    INNER JOIN Rakamin_KF_Analytics.kf_product AS p
        ON ft.product_id = p.product_id
);




