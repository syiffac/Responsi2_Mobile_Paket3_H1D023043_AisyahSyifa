class Book {
  final int? id;
  final String judul;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final int volume;
  final String penulis;
  final String penerbit;

  Book({
    this.id,
    required this.judul,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.volume,
    required this.penulis,
    required this.penerbit,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      judul: json['judul'] ?? '',
      harga: json['harga'] is String
          ? int.parse(json['harga'])
          : json['harga'] ?? 0,
      jumlah: json['jumlah'] is String
          ? int.parse(json['jumlah'])
          : json['jumlah'] ?? 0,
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      volume: json['volume'] is String
          ? int.parse(json['volume'])
          : json['volume'] ?? 0,
      penulis: json['penulis'] ?? '',
      penerbit: json['penerbit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
      'volume': volume,
      'penulis': penulis,
      'penerbit': penerbit,
    };
  }

  Book copyWith({
    int? id,
    String? judul,
    int? harga,
    int? jumlah,
    String? tanggalMasuk,
    int? volume,
    String? penulis,
    String? penerbit,
  }) {
    return Book(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      harga: harga ?? this.harga,
      jumlah: jumlah ?? this.jumlah,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      volume: volume ?? this.volume,
      penulis: penulis ?? this.penulis,
      penerbit: penerbit ?? this.penerbit,
    );
  }
}
