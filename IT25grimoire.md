# No 7

- A. Round Robin

![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/02c67d12-409e-4168-8945-0daabbed429f)

- B. Least Connection

![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/d1b5e0e3-2209-41a9-81a4-04d8213e9164)

- C. Ip hash
  
![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/303f4e6c-66ec-4f72-9b16-75928829f849)



***Grafik***
![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/26d9c1f0-26cc-4386-9196-f05f087199f3)
Grafik yang diatas menunjukkan hasil benchmark tiga algoritma load balancing, antara algoritma Round Robin, Least Connection, dan IP Hash. benchmark dilakukan dengan mengirimkan 200 request dengan interval 10 requests per detik.
Dari grafik diatas dapat dilihat bahwa:
-  1. Round Robin memiliki rata-rata waktu respons tertinggi, yaitu sekitar 2,7 detik.
-  2. Least Connection memiliki rata-rata waktu respons terendah, yaitu sekitar 2,3 detik.
-  3. IP Hash memiliki rata-rata waktu respons yaitu sekitar 2,5 detik.
### Kesimpulan
Berdasarkan hasil benchmark dapat disimpulkan bahwa algoritma Least Connection adalah algoritma load balancing yang paling optimal dalam hal waktu respons. Dari literatur yang ada algoritma ini bekerja dengan cara memilih server dengan jumlah koneksi aktif paling sedikit untuk setiap request. Sehingga ini menyebabkan beban kerja dapat didistribusikan secara lebih merata, sehingga waktu respons menjadi lebih cepat.

# RRWORKER
![image](https://github.com/chocoricano/Jarkom-Modul-3-IT25-2023/assets/56831859/d33b01ba-a43a-4b3d-bd0c-23cbf55d89fd)
Dari grafik diatas menunjukkan hasil benchmark pada algoritma load balancer Round Robin dengan 1 worker, 2 workers dan 3 workers. Benchmark dilakukan dengan mengirimkan 100 request dengan interval 10 requests per detik.

Dari grafik diatas dapat dilihat bahwa:
-  Dengan jumlah worker 1, load balancer hanya dapat menangani sekitar 1.700 request per detik. 
-  Dengan jumlah worker 2, load balancer dapat menangani sekitar 1.900 request per detik. 
-  Dengan jumlah worker 3, load balancer dapat menangani sekitar 2.000 request per detik
Peningkatan kapasitas load balancer tidak linear. Peningkatan kapasitas dari jumlah worker 1 ke 2 lebih besar daripada peningkatan kapasitas dari jumlah worker 2 ke 3. Hal ini karena load balancer memiliki overhead untuk mengelola worker-workernya

### Kesumpulan
Berdasarkan hasil benchamark yang diminta pada modul ini dapat disimpulkan bahwa jika jumlah worker yang lebih banyak akan meningkatkan kapasitas load balancer. Namun, perlu dipertimbangkan bahwa peningkatan kapasitas tidak linear dan ada overhead yang harus ditanggung oleh load balancer.
