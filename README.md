# Blocky Speedrun: Co-op Edition

**Proyek Ujian Akhir Semester (UAS)**

* **Nama:** Hanif Ubaidur Rohman Syah
* **NIM:** 23106050081
* **Program Studi:** Teknik Informatika
* **Universitas:** UIN Sunan Kalijaga
* **Platform:** Roblox Studio

## Deskripsi Singkat

**Blocky Speedrun: Co-op Edition** adalah sebuah game 3D Platformer / Obstacle Course (Obby) di mana pemain harus melewati berbagai rintangan abstrak dan laser mematikan. Game ini menonjolkan fitur *Co-op Multiplayer* yang memungkinkan pemain untuk saling membantu (menggendong) melewati rintangan yang sulit, serta sistem *Infinity Loop* di mana permainan dapat diulang terus-menerus tanpa perlu memulai ulang server.

## Fitur Utama & Mekanik

* **Sprint / Overclock:** Pemain dapat berlari lebih cepat dari kecepatan normal untuk melompati jurang yang lebar.
* **Co-op Carry System:** Pemain dapat menggendong pemain lain di punggungnya untuk melewati rintangan bersama.
* **Anti-Cheat Checkpoint:** Sistem *checkpoint* berbasis perubahan warna material yang mencegah pemain mengeksploitasi poin di tempat yang sama.
* **Dynamic Blinking Lasers:** Rintangan laser neon yang menyala dan mati secara berkala menggunakan sistem *looping script*.
* **Infinity Loop Finish Line:** Garis akhir yang akan mereset memori *checkpoint* seluruh map dan mengembalikan pemain ke titik awal untuk mengumpulkan poin tanpa batas.

## Panduan Kontrol Pemain

* **W, A, S, D / Arrow Keys:** Bergerak
* **Spacebar:** Melompat
* **Shift Kiri (Tahan):** Berlari Cepat (*Sprint*)
* **Tombol E:** Menggendong / Menurunkan pemain lain (arahkan karakter ke pemain target)

## Struktur Folder Proyek

Saat diekstrak, proyek ini memiliki struktur berikut:

```text
📦 UAS_Game_Roblox
 ┣ 📂 Docs
 ┃ ┗ 📜 GDD.txt                 # Dokumen Game Design lengkap
 ┣ 📂 Scripts                   # Kumpulan kode sumber (Lua)
 ┃ ┣ 📜 BlinkScript.lua
 ┃ ┣ 📜 CarryScript.lua
 ┃ ┣ 📜 CheckpointScript.lua
 ┃ ┣ 📜 FinishScript.lua
 ┃ ┣ 📜 FixKamera.lua
 ┃ ┣ 📜 GroupKillScript.lua
 ┃ ┣ 📜 HideMyPrompt.lua
 ┃ ┣ 📜 JurangScript.lua
 ┃ ┣ 📜 Leaderboard.lua
 ┃ ┣ 📜 Leaderstats.lua
 ┃ ┣ 📜 NotifikasiCP.lua
 ┃ ┣ 📜 RespawnManager.lua
 ┃ ┗ 📜 SprintScript.lua
 ┣ 📜 BlockySpeedrun_UAS.rbxl   # File utama game Roblox
 ┗ 📜 README.md                 # Dokumentasi proyek (File ini)

```

## Instruksi Pengujian untuk Penilai (Dosen)

1. Pastikan **Roblox Studio** sudah terinstal di perangkat Anda.
2. Buka file `BlockySpeedrun_UAS.rbxl` dengan cara klik dua kali, atau buka melalui menu *File > Open* di dalam Roblox Studio.
3. Setelah game termuat di layar, klik tombol **Play** (Ikon panah biru) di tab *Home* atau *Test* pada bagian atas layar.
4. Alternatif lain untuk mencoba langsung game via roblox, klik link berikut https://www.roblox.com/share?code=54d49466879f554bb6b9bab6998b64b6&type=ExperienceDetails&stamp=1781599810168
