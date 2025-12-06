# 📚 Inventaris Buku Syiffac

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![CodeIgniter](https://img.shields.io/badge/CodeIgniter-EF4223?style=for-the-badge&logo=codeigniter&logoColor=white)

**Aplikasi manajemen inventaris buku dengan tema retro vintage**

</div>

---

## 👤 Informasi Mahasiswa

| Keterangan | Detail |
|------------|--------|
| **Nama** | Aisyah Syifa Karima |
| **NIM** | H1D023043 |
| **Shift Baru** | C |
| **Shift Asal** | C |

---

## 🎬 Demo Aplikasi

> 📹 **Video Demo:** [Link Video Demo Aplikasi](https://youtube.com/your-video-link)

### Screenshot Aplikasi

<details>
<summary>📱 Klik untuk melihat screenshot</summary>

| Splash Screen | Login | Register |
|:-------------:|:-----:|:--------:|
| *Tampilan awal* | *Halaman login* | *Halaman daftar* |

| Home | Detail Buku | Tambah Buku |
|:----:|:-----------:|:-----------:|
| *Daftar buku* | *Info detail* | *Form tambah* |

</details>

---

## 🔧 Spesifikasi API

Aplikasi ini menggunakan **REST API** dengan backend **CodeIgniter 4**.

### Base URL
```
http://10.45.98.208:8080
```

### Endpoints

#### 🔐 Authentication

| Method | Endpoint | Deskripsi | Body Request |
|--------|----------|-----------|--------------|
| `POST` | `/register` | Registrasi user baru | `name`, `email`, `password` |
| `POST` | `/login` | Login user | `email`, `password` |
| `POST` | `/logout` | Logout user | - |

#### 📖 Books Management

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| `GET` | `/books` | Mengambil semua data buku | ✅ Bearer Token |
| `GET` | `/books/{id}` | Mengambil detail buku | ✅ Bearer Token |
| `POST` | `/books` | Menambah buku baru | ✅ Bearer Token |
| `PUT` | `/books/{id}` | Mengupdate data buku | ✅ Bearer Token |
| `DELETE` | `/books/{id}` | Menghapus buku | ✅ Bearer Token |

### Struktur Data Buku

```json
{
  "id": 1,
  "judul": "Laskar Pelangi",
  "penulis": "Andrea Hirata",
  "penerbit": "Bentang Pustaka",
  "harga": 85000,
  "stok": 25,
  "volume": 1,
  "tanggal_masuk": "2024-01-15"
}
```

### Response Format

**Success Response:**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error description"
}
```

---

## 📁 Struktur Proyek

```
lib/
├── main.dart                 # Entry point & tema aplikasi
├── models/
│   └── book.dart            # Model data buku
├── screens/
│   ├── login_screen.dart    # Halaman login
│   ├── register_screen.dart # Halaman registrasi
│   ├── home_screen.dart     # Halaman utama (list buku)
│   ├── add_book_screen.dart # Form tambah buku
│   ├── edit_book_screen.dart# Form edit buku
│   └── book_detail_screen.dart # Detail buku
├── services/
│   ├── api_service.dart     # HTTP client wrapper
│   ├── auth_service.dart    # Autentikasi (login/register/logout)
│   └── book_service.dart    # CRUD operasi buku
└── utils/
    ├── constants.dart       # Warna & konstanta
    └── validators.dart      # Validasi input form
```

---

## 📝 Penjelasan Fungsi Aplikasi

### 1. `main.dart` - Entry Point & Splash Screen

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}
```

| Fungsi | Deskripsi |
|--------|-----------|
| `main()` | Inisialisasi aplikasi, setup locale Indonesia untuk format tanggal |
| `MyApp` | Root widget yang mengatur tema vintage (warna, font Playfair Display & Lora) |
| `SplashScreen` | Tampilan awal dengan animasi logo, mengecek status login user |
| `_checkAuth()` | Memvalidasi token tersimpan, redirect ke Home atau Login |

---

### 2. `auth_service.dart` - Layanan Autentikasi

| Fungsi | Deskripsi |
|--------|-----------|
| `register()` | Mendaftarkan user baru dengan nama, email, password |
| `login()` | Autentikasi user, menyimpan token ke SharedPreferences |
| `logout()` | Menghapus token dan data user dari penyimpanan lokal |
| `isLoggedIn()` | Mengecek apakah user sudah login (token valid) |
| `getToken()` | Mengambil token untuk header Authorization |
| `getUserData()` | Mengambil data user yang tersimpan |

```dart
// Contoh penggunaan login
static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final response = await ApiService.post(
    AppConstants.loginEndpoint,
    body: {'email': email, 'password': password},
    withAuth: false,
  );
  // Simpan token jika berhasil
  if (response.success) {
    await _saveToken(response.data['token']);
  }
  return response.toMap();
}
```

---

### 3. `book_service.dart` - Layanan CRUD Buku

| Fungsi | Deskripsi |
|--------|-----------|
| `getBooks()` | Mengambil semua buku dari API |
| `getBookById(id)` | Mengambil detail satu buku berdasarkan ID |
| `createBook(book)` | Menambahkan buku baru ke database |
| `updateBook(id, book)` | Mengupdate data buku yang sudah ada |
| `deleteBook(id)` | Menghapus buku dari database |

```dart
// Contoh: Mengambil semua buku
static Future<Map<String, dynamic>> getBooks() async {
  final response = await ApiService.get(AppConstants.booksEndpoint);
  if (response.success && response.data != null) {
    List<Book> books = (response.data as List)
        .map((json) => Book.fromJson(json))
        .toList();
    return {'success': true, 'data': books};
  }
  return response.toMap();
}
```

---

### 4. `login_screen.dart` - Halaman Login

| Fungsi | Deskripsi |
|--------|-----------|
| `_login()` | Memproses login, validasi form, panggil AuthService |
| `_buildTextField()` | Widget reusable untuk input field dengan styling vintage |
| `_buildLoginButton()` | Tombol login dengan gradient dan loading state |

**Fitur:**
- ✅ Validasi email format
- ✅ Validasi password minimal 6 karakter
- ✅ Animasi fade & slide saat muncul
- ✅ Toggle visibility password
- ✅ Navigasi ke halaman Register

---

### 5. `register_screen.dart` - Halaman Registrasi

| Fungsi | Deskripsi |
|--------|-----------|
| `_register()` | Memproses registrasi user baru |
| `_showSnackBar()` | Menampilkan notifikasi sukses/error |

**Validasi:**
- Nama minimal 3 karakter
- Email format valid
- Password minimal 6 karakter
- Konfirmasi password harus cocok

---

### 6. `home_screen.dart` - Halaman Utama

| Fungsi | Deskripsi |
|--------|-----------|
| `_loadBooks()` | Fetch data buku dari API, update state |
| `_calculateStats()` | Menghitung total buku dan total stok |
| `_deleteBook(id)` | Menghapus buku dengan konfirmasi dialog |
| `_logout()` | Proses logout dengan konfirmasi |
| `_buildVintageDrawer()` | Sidebar dengan statistik dan menu navigasi |
| `_buildVintageBookCard()` | Card buku dengan tampilan vintage |

**Fitur:**
- 📊 Statistik total buku & stok di drawer
- 🔄 Pull-to-refresh untuk reload data
- ⚠️ Indikator stok rendah (< 5 unit)
- 🎨 Animasi list saat data dimuat

---

### 7. `add_book_screen.dart` - Form Tambah Buku

| Fungsi | Deskripsi |
|--------|-----------|
| `_selectDate()` | Membuka date picker untuk tanggal masuk |
| `_saveBook()` | Validasi form & simpan buku ke API |
| `_buildSectionCard()` | Card section dengan icon dan judul |

**Field Input:**
- Judul buku
- Penulis
- Penerbit
- Harga
- Jumlah (stok)
- Volume
- Tanggal masuk

---

### 8. `edit_book_screen.dart` - Form Edit Buku

| Fungsi | Deskripsi |
|--------|-----------|
| `_updateBook()` | Update data buku ke API |
| Pre-fill data | Mengisi form dengan data buku existing |

---

### 9. `book_detail_screen.dart` - Detail Buku

| Fungsi | Deskripsi |
|--------|-----------|
| `_formatCurrency()` | Format harga ke Rupiah (Rp 85.000) |
| `_formatDate()` | Format tanggal ke Indonesia (15 Januari 2024) |
| `_deleteBook()` | Hapus buku dengan dialog konfirmasi |
| `_editBook()` | Navigasi ke halaman edit, refresh data setelah kembali |
| `_buildStatCard()` | Card statistik harga & stok |
| `_buildDetailRow()` | Row informasi dengan icon |

**Informasi Ditampilkan:**
- 💰 Harga per unit
- 📦 Jumlah stok
- 💵 Total nilai inventaris (harga × stok)
- ✍️ Penulis
- 🏢 Penerbit
- 📅 Tanggal masuk
- 📖 Volume

---

### 10. `book.dart` - Model Data

```dart
class Book {
  final int? id;
  final String judul;
  final String penulis;
  final String penerbit;
  final int harga;
  final int jumlah;
  final int volume;
  final String tanggalMasuk;

  // Constructor, fromJson, toJson
}
```

| Method | Deskripsi |
|--------|-----------|
| `fromJson()` | Konversi JSON response ke object Book |
| `toJson()` | Konversi object Book ke JSON untuk request |

---

### 11. `validators.dart` - Validasi Input

| Fungsi | Deskripsi |
|--------|-----------|
| `validateEmail()` | Validasi format email dengan regex |
| `validatePassword()` | Validasi password minimal 6 karakter |
| `validateRequired()` | Validasi field tidak boleh kosong |
| `validatePositiveNumber()` | Validasi input harus angka positif |

---

### 12. `constants.dart` - Konstanta Aplikasi

**Warna Tema Vintage:**
```dart
static const Color primary = Color(0xFF8B4513);     // Saddle Brown
static const Color gold = Color(0xFFD4AF37);        // Gold
static const Color burgundy = Color(0xFF722F37);    // Burgundy
static const Color olive = Color(0xFF556B2F);       // Olive Green
static const Color background = Color(0xFFFAF0E6); // Linen (cream)
```

**API Endpoints:**
```dart
static const String baseUrl = 'http://10.45.98.208:8080';
static const String loginEndpoint = '/login';
static const String booksEndpoint = '/books';
```

---

## 🎨 Tema & Desain

Aplikasi menggunakan tema **Retro Vintage** dengan karakteristik:

- **Font:** Playfair Display (heading), Lora (body)
- **Warna:** Brown, Gold, Cream, Burgundy
- **Elemen Dekoratif:** Border gold, vintage corners, star dividers
- **Style:** Clean, elegant, tidak berlebihan

---

## 🚀 Cara Menjalankan

1. **Clone repository**
   ```bash
   git clone https://github.com/syiffac/Responsi2_Mobile_Paket3_H1D023043_AisyahSyifa.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   # Android/iOS
   flutter run
   
   # Web (dengan CORS disabled)
   flutter run -d chrome --web-browser-flag "--disable-web-security"
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  intl: ^0.18.1
  google_fonts: ^6.1.0
```

---

<div align="center">

**Made with ❤️ by Aisyah Syifa Karima**

*Responsi 2 Pemrograman Mobile - 2024*

</div>
