HEAD
# 🌟 Portofolio Digital & Laboratorium PBO (Flutter Web)

Aplikasi Web Portofolio dengan tema **Minimalis Elegan**, efek animasi kosmik (partikel konstelasi & glowing ambient orbs), serta integrasi mendalam materi kuliah **Pemrograman Berorientasi Objek (PBO)**.

---

## 🚀 Fitur Unggulan Sesuai Permintaan Tugas

1. **Folder `models/` Terstruktur & Sesuai Standar PBO**
   - [`lib/models/user_model.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/models/user_model.dart): Menerapkan **Abstraksi** (`abstract class BaseUser`), **Enkapsulasi** (properti privat `_id`, `_username`, dll dengan getter validasi), **Pewarisan** (`extends`), dan **Polimorfisme** (`getRoleTitle()`, `getClearanceLevel()`, `getRoleColor()`). Memiliki turunan peran:
     - 🎓 `AcademicEvaluatorUser` (Dosen / Penilai Akademik PBO)
     - 💼 `RecruiterUser` (Talent Acquisition)
     - 🚀 `DeveloperGuestUser` (Software Engineer Guest)
   - [`lib/models/portfolio_item.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/models/portfolio_item.dart): Blueprint hirarkis item portofolio dengan turunan `PboCourseworkItem` dan `SoftwareAppItem`, serta kontrak antarmuka `InteractiveDemonstrable`.
   - [`lib/models/pbo_concept_model.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/models/pbo_concept_model.dart): Model 4 pilar utama PBO (Enkapsulasi, Pewarisan, Polimorfisme, Abstraksi) yang dilengkapi simulasi eksekusi runtime interaktif.

2. **Foto Berbentuk Lingkaran (`CircularProfileAvatar`)**
   - Terletak di [`lib/widgets/circular_profile_avatar.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/widgets/circular_profile_avatar.dart).
   - Menampilkan avatar circular (`ClipOval` / `CircleAvatar`) dengan:
     - **Rotating Gradient Sweep Ring** (Border berputar 360 derajat halus)
     - **Status Badge Pulsing Hijau** (indikator online / siap kolaborasi)
     - **Micro-badge PBO A+**
     - **Hover Scale & Glow Animation** saat kursor diarahkan.

3. **Penerapan `ListView.builder` Interaktif**
   - Terletak di [`lib/pages/home_page.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/pages/home_page.dart):
     - **Horizontal `ListView.builder`**: Menampilkan kartu 4 Pilar Utama PBO (Enkapsulasi, Pewarisan, Polimorfisme, Abstraksi) dengan tombol uji simulasi kode.
     - **Vertical `ListView.builder`**: Menampilkan daftar koleksi proyek dan tugas akademik dengan filter kategori dinamis (*Semua*, *Tugas PBO*, *Mobile*, *Web*).

4. **Integrasi Mata Kuliah PBO (Pemrograman Berorientasi Objek)**
   - Menghubungkan secara nyata proyek kuliah seperti:
     - **Tugas UTS PBO**: Hirarki Akun Game FPS vs MOBA (Superclass `AkunGame`, Subclasses `AkunFPS` & `AkunMOBA`).
     - **Tugas UAS PBO**: Sistem Reservasi & Transaksi Perbankan OOP dengan Enkapsulasi Saldo & Polimorfisme Transfer.
     - **Praktikum PBO**: Simulasi Ekosistem Predator-Prey dengan dynamic binding.
   - Dilengkapi **PBO Interactive Simulator** ([`lib/widgets/pbo_interactive_sheet.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/widgets/pbo_interactive_sheet.dart)) yang dapat dijalankan langsung di aplikasi untuk melihat output runtime.

5. **Halaman Login Kreatif (Bukan Template Biasa)**
   - Terletak di [`lib/pages/login_page.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/pages/login_page.dart) & [`lib/widgets/cyber_login_card.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/widgets/cyber_login_card.dart).
   - Mengusung tema **"Visitor Access Pass & Cyber Gateway"**:
     - **Holographic ID Badge** dengan visual NFC chip & fingerprint scanner.
     - **1-Click Fast Pass**: Pilihan langsung hak akses Dosen Evaluator PBO (Level 5 Clearance), Recruiter (Level 3), atau Software Engineer (Level 2).
     - **Custom Terminal Mode**: Masuk dengan username/password kustom, lengkap dengan simulasi hashing kriptografis dan status dekripsi token.

6. **Tema Minimalis Elegan & Animasi Latar Belakang Mutakhir**
   - Terletak di [`lib/widgets/animated_background.dart`](file:///f:/tugas%20flutter/tugas_flutter/lib/widgets/animated_background.dart).
   - Kanvas `CustomPainter` 60 FPS:
     - Partikel konstelasi yang otomatis membentuk garis jaring (mesh) saat saling mendekati.
     - Floating Aurora Orbs (cahaya neon indigo, cyan, emerald yang melayang lembut).
     - Cyber Matrix Grid & respons interaktif terhadap kursor mouse.

---

## 📂 Struktur Direktori Proyek

```
tugas_flutter/
├── lib/
│   ├── models/
│   │   ├── user_model.dart            # Model PBO: Abstraksi, Enkapsulasi, Pewarisan, Polimorfisme
│   │   ├── portfolio_item.dart        # Blueprint Item Portofolio & Tugas Matkul PBO
│   │   └── pbo_concept_model.dart     # Model 4 Pilar PBO + Runner Simulasi
│   ├── services/
│   │   ├── auth_service.dart          # Singleton Service Autentikasi Pengunjung
│   │   └── portfolio_service.dart     # Service Data Portofolio & Tugas Kuliah
│   ├── theme/
│   │   ├── app_colors.dart            # Palet Warna Minimalis Elegan (Obsidian, Cyan, Indigo)
│   │   └── app_theme.dart             # Konfigurasi Tema Gelap & Google Fonts
│   ├── widgets/
│   │   ├── animated_background.dart   # Animasi Partikel Konstelasi & Ambient Aura Orbs
│   │   ├── circular_profile_avatar.dart # Foto Profil Lingkaran dengan Rotating Border
│   │   ├── cyber_login_card.dart      # Kartu Akses Login Kreatif (Holographic Badge)
│   │   ├── nav_bar.dart               # Top Glassmorphic Navigation Bar
│   │   ├── project_card.dart          # Komponen Kartu untuk ListView.builder
│   │   └── pbo_interactive_sheet.dart # Terminal Eksekusi Kode PBO Interaktif
│   ├── pages/
│   │   ├── login_page.dart            # Landing Page Login Kreatif
│   │   └── home_page.dart             # Home Page Portofolio & Lab PBO
│   └── main.dart                      # Titik Masuk Utama Aplikasi
└── test/
    └── widget_test.dart               # Smoke Test Unit (Passed)
```

---

## 💻 Cara Menjalankan Aplikasi di Web

Buka terminal pada folder `f:/tugas flutter/tugas_flutter` lalu jalankan perintah:

```bash
# Menjalankan di browser Chrome (Flutter Web)
flutter run -d chrome
```

Atau untuk build versi rilis web:
```bash
flutter build web --release
```

# pbpflutter
64ea78d8ec12c4e5304d4ab8e910af54c872cb4d
