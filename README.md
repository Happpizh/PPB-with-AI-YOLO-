### Nama : Nadin Nabil Hafizh Ayyasy
### NRP : 5025231061

## Penjelasan AI 
1. Karena saya ikut GRS jadi saya pakai model yang sudah saya train yaitu deteksi pohon sawit 
2. Untuk dataset saya pakai roboflow : https://app.roboflow.com/hafizh-th25j/grs2-wl44g/2
3. Saya pakai yolov8n lalu di convert ke tflite : https://colab.research.google.com/drive/1LUWecAMPDD9pwcHiI3mg_dI9Wqv4CVjB?usp=sharing
4. Untuk hasil runs train nya : https://drive.google.com/drive/folders/1MrCrwwL8T6ZYxVlNgD0VQIHRwDmlA9m6?usp=sharing

## Penjelasan Aplikasi
1. Aplikasi adalah untuk mendeteksi pohon sawit dar citra satelit dan menghitung nya
2. Ada dua fitur yaitu Live Camera dan Static Image dari hasil foto atau galeri
3. Contoh Live Camera
   <img width="480" height="1067" alt="Image" src="https://github.com/user-attachments/assets/72bf2eb8-5ac3-4e51-9ddd-de7757f7f660" />
4. Contoh Static Image
   <img width="480" height="1067" alt="Image" src="https://github.com/user-attachments/assets/a439e8df-a73b-4aab-bdb5-148a86174d4c" />

## Penjelasan Kode
1. Saya mengikuti di github kelas yaitu pakai ultralytics untuk membca model dan livecamera nya dan juga image picker tentunya
  ```
  ultralytics_yolo: ^0.3.0
  image_picker: ^1.0.7
  ```
3. Jangan lupa import model di pubspec.yaml
  ```
  assets:
      - assets/models/
  ```
4. Tambahkan permission untuk kamera
  ```
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-feature android:name="android.hardware.camera" android:required="true" />
  ```
5. main_screen.dart untuk sebagai contoler navigasi utama aplikasi. File ini membungkus kedua fitur utama, jadi bisa berpindah antara mode Live Camera dan mode Static Image dengan lancar tanpa perlu memuat ulang halamannya.
6. live_camera_screen.dart untuk fitur Live Cameranya, mengimplementasikan "YOLOView" dari Ultraliytics
7. static_image_screen.dart untuk fitur Static Image, Modul yang menangani komputasi gambar statis (foto). File ini menggunakan paket "image_picker" untuk mengambil gambar, mengonversinya menjadi byte array , dan mengirimkannya ke fungsi "yolo.predict()". Modul ini juga secara manual mengekstrak output raw data berupa map untuk menghitung total pohon dan merender ulang citra yang telah dianotasi oleh AI ke layar.
