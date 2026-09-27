import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_flutter/models/models.dart';

void main() {
  group('PBO Blueprint & Enkapsulasi: MahasiswaModel Tests', () {
    test('1. Blueprint instansiasi objek dan validitas default getter', () {
      final mhs = MahasiswaModel.defaultStudent();

      expect(mhs.nim, '2024091001');
      expect(mhs.nama, 'Ahmad Fauzan');
      expect(mhs.semester, 4);
      expect(mhs.ipk, 3.92);
      expect(mhs.ipkFormatted, '3.92');
      expect(mhs.isCumLaude, isTrue);
      expect(mhs.predikatKelulusan, 'Dengan Pujian (Cum Laude)');
      expect(mhs.totalSks, 84);
      expect(mhs.sisaSksLulus, 60); // 144 - 84
      expect(mhs.persentaseKelulusan, closeTo(58.33, 0.1));
    });

    test('2. Named Constructor: MahasiswaModel.freshman', () {
      final freshman = MahasiswaModel.freshman(
        nim: '2026110055',
        nama: 'Budi Santoso',
        email: 'budi@kampus.ac.id',
      );

      expect(freshman.semester, 1);
      expect(freshman.ipk, 0.0);
      expect(freshman.totalSks, 0);
      expect(freshman.sisaSksLulus, 144);
      expect(freshman.isCumLaude, isFalse);
    });

    test('3. Setter: Mutasi status valid pada _ipk, _nama, dan _semester', () {
      final mhs = MahasiswaModel.defaultStudent();

      // Mutasi IPK via setter
      mhs.ipk = 3.65;
      expect(mhs.ipk, 3.65);
      expect(mhs.ipkFormatted, '3.65');
      expect(mhs.predikatKelulusan, 'Sangat Memuaskan');
      expect(mhs.isCumLaude, isFalse);

      // Mutasi Semester
      mhs.semester = 6;
      expect(mhs.semester, 6);

      // Mutasi Nama
      mhs.nama = '  Ahmad Fauzan S.Kom.  ';
      expect(mhs.nama, 'Ahmad Fauzan S.Kom.');
    });

    test('4. Setter Enkapsulasi: Validasi batas aturan bisnis melempar ArgumentError', () {
      final mhs = MahasiswaModel.defaultStudent();

      // Tes IPK negatif
      expect(() => mhs.ipk = -0.5, throwsA(isA<ArgumentError>()));

      // Tes IPK melebihi batas 4.00
      expect(() => mhs.ipk = 4.05, throwsA(isA<ArgumentError>()));

      // Tes Semester di luar rentang wajar (1-14)
      expect(() => mhs.semester = 0, throwsA(isA<ArgumentError>()));
      expect(() => mhs.semester = 15, throwsA(isA<ArgumentError>()));

      // Tes Nama kosong
      expect(() => mhs.nama = '   ', throwsA(isA<ArgumentError>()));

      // Tes Format Email tidak valid
      expect(() => mhs.email = 'email-tanpa-domain', throwsA(isA<ArgumentError>()));
    });

    test('5. Function/Method Operasional Objek: SKS, Keahlian, dan Nilai', () {
      final mhs = MahasiswaModel.defaultStudent();

      // Uji Method tambahSks
      mhs.tambahSks(20);
      expect(mhs.totalSks, 104);
      expect(mhs.sisaSksLulus, 40);

      // Uji Method tambahKeahlian
      final added = mhs.tambahKeahlian('Docker & Kubernetes');
      expect(added, isTrue);
      expect(mhs.keahlian.contains('Docker & Kubernetes'), isTrue);

      // Cegah duplikasi keahlian
      final duplicate = mhs.tambahKeahlian('docker & kubernetes');
      expect(duplicate, isFalse);

      // Uji Method catatNilaiMataKuliah & hitungRataRataNilai
      mhs.catatNilaiMataKuliah('Kecerdasan Buatan', 95.0);
      expect(mhs.nilaiMataKuliah.containsKey('Kecerdasan Buatan'), isTrue);
      expect(mhs.hitungRataRataNilai(), greaterThan(90.0));
    });

    test('6. Evaluasi Kelayakan Skripsi', () {
      final mhs = MahasiswaModel.defaultStudent();
      // Semester 4, SKS 84 -> belum layak
      expect(mhs.evaluasiKelayakanSkripsi(), contains('BELUM MEMENUHI SYARAT'));

      // Penuhi syarat: Semester 7, SKS 130
      mhs.semester = 7;
      mhs.tambahSks(46); // 84 + 46 = 130
      expect(mhs.evaluasiKelayakanSkripsi(), contains('MEMENUHI SYARAT'));
    });
  });

  group('PBO Blueprint & Penilaian: ProjectEvaluationModel Tests', () {
    test('1. Blueprint instansiasi & kalkulasi bobot nilai akhir', () {
      final audit = ProjectEvaluationModel(
        projectId: 'PBO-TEST-01',
        projectTitle: 'Testing Blueprint PBO',
        evaluatorName: 'Dosen Penguji',
        skorArsitekturPbo: 100.0, // 35% -> 35
        skorEnkapsulasi: 100.0,   // 25% -> 25
        skorPolimorfisme: 90.0,   // 20% -> 18
        skorAntarmukaUi: 90.0,    // 20% -> 18
      );

      // Total = 35 + 25 + 18 + 18 = 96.0
      expect(audit.nilaiAkhir, closeTo(96.0, 0.001));
      expect(audit.nilaiAkhirFormatted, '96.00');
      expect(audit.isLulus, isTrue);
      expect(audit.hurufMutu, contains('A (Sangat Istimewa)'));
    });

    test('2. Setter enkapsulasi rubrik skor melempar ArgumentError jika di luar 0-100', () {
      final audit = ProjectEvaluationModel.defaultAudit();

      expect(() => audit.skorArsitekturPbo = 105.0, throwsA(isA<ArgumentError>()));
      expect(() => audit.skorEnkapsulasi = -5.0, throwsA(isA<ArgumentError>()));
    });
  });

  group('PBO Pewarisan & Polimorfisme: BaseUser Hierarchy Tests', () {
    test('1. Polimorfisme dinamik dispatch getRoleTitle() dan getPermissions()', () {
      final List<BaseUser> users = [
        AcademicEvaluatorUser(
          id: 'u1',
          username: 'dosen_pbo',
          displayName: 'Dr. Hendra',
          avatarUrl: 'https://example.com/avatar1.png',
        ),
        RecruiterUser(
          id: 'u2',
          username: 'hr_lead',
          displayName: 'Sarah Recruiter',
          avatarUrl: 'https://example.com/avatar2.png',
        ),
        DeveloperGuestUser(
          id: 'u3',
          username: 'dev_guest',
          displayName: 'Alex Guest',
          avatarUrl: 'https://example.com/avatar3.png',
        ),
        MahasiswaAuthorUser(
          id: 'u4',
          username: 'author_dev',
          displayName: 'Ahmad Fauzan',
          avatarUrl: 'https://example.com/avatar4.png',
          nim: '2024091001',
        ),
      ];

      // Verifikasi polimorfisme: Panggilan method yang sama menghasilkan respons spesifik
      expect(users[0].getRoleTitle(), contains('Dosen / Penilai Akademik PBO'));
      expect(users[1].getRoleTitle(), contains('Tech Talent Recruiter'));
      expect(users[2].getRoleTitle(), contains('Software Engineer Guest'));
      expect(users[3].getRoleTitle(), contains('Mahasiswa Pengembang'));

      // Uji setter pada BaseUser
      users[0].displayName = 'Prof. Dr. Hendra M.Kom';
      expect(users[0].displayName, 'Prof. Dr. Hendra M.Kom');

      // Validasi setter displayName tidak boleh kosong
      expect(() => users[0].displayName = '', throwsA(isA<ArgumentError>()));
    });
  });
}
