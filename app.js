/**
 * DATA PRODUK / BUDAYA KEPRI
 * ---------------------------
 * Tim Developer: Untuk menambahkan produk/artefak baru, cukup tambahkan data di bawah ini.
 * Pastikan ID unik dan gambar tersedia di folder assets/images/
 */
const budayaData = [
    {
        id: 'gasing',
        title: 'Gasing Melayu',
        location: 'Pulau Penyengat',
        category: 'Artefak 3D',
        image: 'assets/images/gasing_3d.png',
        hasAR: true,
        rating: '5.0',
        reviews: 300,
        stats: { time: 'Abad ke-19', material: 'Kayu Pelawan' },
        tabs: {
            sejarah: 'Gasing merupakan permainan tradisional masyarakat Melayu Kepulauan Riau yang sangat populer di Pulau Penyengat. Permainan ini mengandung nilai sejarah dan kebersamaan.',
            'cara main': 'Dulu gasing dimainkan oleh kaum pria pada saat musim panen tiba. Gasing Melayu memiliki ciri khas ukuran besar dan putaran yang lama.',
            filosofi: 'Keseimbangan gasing yang presisi melambangkan keseimbangan hidup dalam budaya Melayu.'
        },
        // Ganti link .glb dan .usdz di bawah ini dengan model 3D aslimu nanti
        arModelSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        arModelIos: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz'
    },
    {
        id: 'keramik-ssba',
        title: 'Guci Keramik Cina',
        location: 'Museum Sultan Sulaiman',
        category: 'Keramologika',
        image: 'assets/images/keramik.png',
        hasAR: true,
        rating: '4.8',
        reviews: 125,
        stats: { time: 'Dinasti Ming', material: 'Tanah Liat/Porselen' },
        tabs: {
            sejarah: 'Museum Sultan Sulaiman Badrul Alamsyah memiliki koleksi Keramologika berupa guci dan piring porselen yang berasal dari Cina, Jepang, hingga Eropa. Ini membuktikan Kepri sebagai pusat perdagangan dunia.',
            informasi: 'Ditemukan di perairan Kepulauan Riau dari kapal-kapal dagang yang karam berabad-abad lalu.',
            filosofi: 'Menyimbolkan keterbukaan dan jalur rempah yang menghubungkan Kesultanan Melayu dengan dunia luar.'
        },
        arModelSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        arModelIos: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz'
    },
    {
        id: 'tari-zapin',
        title: 'Tari Zapin Penyengat',
        location: 'Pulau Penyengat',
        category: 'Seni Tari',
        image: 'assets/images/zapin.png',
        hasAR: false, // Tidak ada AR karena ini tarian
        rating: '4.9',
        reviews: 210,
        stats: { time: 'Abad ke-16', material: 'Akulturasi Budaya' },
        tabs: {
            sejarah: 'Tari Zapin berasal dari bahasa Arab "Zafn" yang berarti pergerakan kaki cepat. Dibawa oleh pedagang dari Yaman pada abad ke-16 dan berakulturasi dengan budaya Melayu di Kesultanan Riau-Lingga.',
            'cara main': 'Diiringi musik petik gambus dan tabuhan marwas. Gerakan kaki sangat dominan dan lincah mengikuti rentak musik.',
            filosofi: 'Tarian ini sarat dengan nilai-nilai dakwah Islam dan adab kesopanan masyarakat Melayu.'
        }
    },
    {
        id: 'museum-ssba',
        title: 'Museum S.S. Badrul Alamsyah',
        location: 'Tanjungpinang',
        category: 'Tempat Sejarah',
        image: 'assets/images/museum_tpi.png',
        hasAR: false,
        rating: '4.9',
        reviews: 450,
        stats: { time: 'Era Kolonial', material: 'Bangunan Cagar Budaya' },
        tabs: {
            sejarah: 'Gedung ini awalnya adalah sebuah sekolah zaman kolonial Belanda (Hollandsch-Inlandsche School/HIS) yang dibangun tahun 1918. Kini menjadi museum yang menyimpan 2.613 koleksi benda bersejarah.',
            informasi: 'Koleksi dibagi 8 jenis: Etnografi, Keramologika, Teknologika, Historika, Numismatika, Filologika, Arkeologika, dan Seni Rupa.',
            filosofi: 'Menjadi ruang rekam jejak kota Tanjungpinang dari masa ke masa.'
        }
    },
    {
        id: 'pulau-penyengat',
        title: 'Masjid Raya Sultan Riau',
        location: 'Pulau Penyengat',
        category: 'Tempat Sejarah',
        image: 'assets/images/pulau_penyengat.png',
        hasAR: false,
        rating: '5.0',
        reviews: 890,
        stats: { time: '1832 Masehi', material: 'Putih Telur' },
        tabs: {
            sejarah: 'Masjid Raya Sultan Riau di Pulau Penyengat terkenal karena konon putih telur digunakan sebagai campuran bahan perekat bangunannya. Pulau ini adalah pusat pemerintahan Kesultanan Riau-Lingga.',
            informasi: 'Masjid ini memiliki 13 kubah dan 4 menara, total 17 yang melambangkan jumlah rakaat salat fardu.',
            filosofi: 'Simbol kejayaan Islam dan mahakarya arsitektur Melayu Riau.'
        }
    }
];

// State Aplikasi
let currentItem = null;

// Render Daftar Item di Home
function renderHomeList(filterCategory = 'Semua') {
    const container = document.getElementById('locations-container');
    container.innerHTML = ''; // Kosongkan dulu

    const filteredData = filterCategory === 'Semua' 
        ? budayaData 
        : budayaData.filter(item => item.category === filterCategory || (filterCategory === 'Museum' && item.location.includes('Museum')));

    filteredData.forEach(item => {
        const arBadgeHtml = item.hasAR 
            ? `<div class="rating ar-badge"><i class="ph-bold ph-cube"></i> AR Tersedia</div>`
            : `<div class="rating"><i class="ph-fill ph-star"></i> ${item.rating} <span class="reviews">(${item.reviews})</span></div>`;

        const card = document.createElement('div');
        card.className = 'card';
        card.onclick = () => openDetail(item.id);
        card.innerHTML = `
            <img src="${item.image}" alt="${item.title}" class="card-img">
            <div class="card-info">
                <h4>${item.title}</h4>
                <p><i class="ph-fill ph-map-pin"></i> ${item.location}</p>
                ${arBadgeHtml}
            </div>
            <button class="card-action"><i class="ph-bold ph-caret-right"></i></button>
        `;
        container.appendChild(card);
    });
}

// Buka Halaman Detail
function openDetail(id) {
    currentItem = budayaData.find(item => item.id === id);
    if (!currentItem) return;

    // Isi Data ke UI Detail
    document.getElementById('detail-img').src = currentItem.image;
    document.getElementById('detail-title').textContent = currentItem.title;
    document.getElementById('detail-location').innerHTML = `<i class="ph-fill ph-map-pin"></i> ${currentItem.location}, Kepulauan Riau`;
    
    document.getElementById('detail-stat-time').textContent = currentItem.stats.time;
    document.getElementById('detail-stat-material').textContent = currentItem.stats.material;

    // Sembunyikan atau Tampilkan Tombol AR
    const arBadgeLarge = document.getElementById('detail-ar-badge');
    const arBottomBtn = document.getElementById('detail-ar-bottom-btn');
    if (currentItem.hasAR) {
        arBadgeLarge.style.display = 'flex';
        arBottomBtn.style.display = 'flex';
    } else {
        arBadgeLarge.style.display = 'none';
        arBottomBtn.style.display = 'none';
    }

    // Render Tabs Button
    const tabsContainer = document.getElementById('detail-tabs');
    tabsContainer.innerHTML = '';
    const tabKeys = Object.keys(currentItem.tabs);
    
    tabKeys.forEach((key, index) => {
        const btn = document.createElement('button');
        btn.className = `tab-btn ${index === 0 ? 'active' : ''}`;
        btn.textContent = key.charAt(0).toUpperCase() + key.slice(1);
        btn.onclick = (e) => switchTab(e, key);
        tabsContainer.appendChild(btn);
    });

    // Tampilkan konten tab pertama
    document.getElementById('detail-tab-content').innerHTML = `<p>${currentItem.tabs[tabKeys[0]]}</p>`;

    // Navigasi ke Layar Detail
    navigateTo('detail');
}

// Ganti Konten Tab
function switchTab(event, key) {
    // Hapus kelas aktif dari semua tab
    document.querySelectorAll('#detail-tabs .tab-btn').forEach(btn => btn.classList.remove('active'));
    // Tambah kelas aktif ke tab yang di-klik
    event.target.classList.add('active');
    // Ganti konten
    document.getElementById('detail-tab-content').innerHTML = `<p>${currentItem.tabs[key]}</p>`;
}

// Buka Halaman AR
function openAR() {
    if (!currentItem || !currentItem.hasAR) return;

    // Update Model Viewer Source
    const modelViewer = document.getElementById('ar-model-viewer');
    modelViewer.src = currentItem.arModelSrc;
    modelViewer.setAttribute('ios-src', currentItem.arModelIos);
    modelViewer.setAttribute('poster', currentItem.image);
    
    document.getElementById('ar-title').textContent = currentItem.title;

    navigateTo('ar');
}

// Logika Navigasi Antar Layar
function navigateTo(screenId) {
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => screen.classList.remove('active'));

    const target = document.getElementById(`${screenId}-screen`);
    if (target) {
        target.classList.add('active');
        target.scrollTop = 0;
    }

    // Update Bottom Navigation state
    const bottomNav = document.getElementById('main-bottom-nav');
    if (bottomNav) {
        // Tampilkan bottom nav hanya di halaman utama
        const mainScreens = ['home', 'map', 'saved', 'profile'];
        if (mainScreens.includes(screenId)) {
            bottomNav.style.display = 'flex';
            
            // Update ikon aktif
            const navItems = bottomNav.querySelectorAll('.nav-item');
            navItems.forEach(item => item.classList.remove('active'));
            
            // Beri class active sesuai halaman (mengabaikan scan-btn)
            if (screenId === 'home') navItems[0].classList.add('active');
            if (screenId === 'map') navItems[1].classList.add('active');
            if (screenId === 'saved') {
                navItems[3].classList.add('active');
                renderSavedList(); // Render daftar tersimpan
            }
            if (screenId === 'profile') navItems[4].classList.add('active');
            
        } else {
            bottomNav.style.display = 'none';
        }
    }
}

// Render Daftar Tersimpan (Dummy Data)
function renderSavedList() {
    const container = document.getElementById('saved-container');
    container.innerHTML = ''; 

    // Ambil 2 item pertama sebagai contoh "Tersimpan"
    const savedData = [budayaData[0], budayaData[2]]; 

    savedData.forEach(item => {
        const arBadgeHtml = item.hasAR 
            ? `<div class="rating ar-badge"><i class="ph-bold ph-cube"></i> AR Tersedia</div>`
            : `<div class="rating"><i class="ph-fill ph-star"></i> ${item.rating} <span class="reviews">(${item.reviews})</span></div>`;

        const card = document.createElement('div');
        card.className = 'card';
        card.onclick = () => openDetail(item.id);
        card.innerHTML = `
            <img src="${item.image}" alt="${item.title}" class="card-img">
            <div class="card-info">
                <h4>${item.title}</h4>
                <p><i class="ph-fill ph-map-pin"></i> ${item.location}</p>
                ${arBadgeHtml}
            </div>
            <button class="card-action"><i class="ph-bold ph-bookmark-simple"></i></button>
        `;
        container.appendChild(card);
    });
}

// Inisialisasi Aplikasi Saat Dimuat
document.addEventListener('DOMContentLoaded', () => {
    // Render List Beranda
    renderHomeList();

    // Logika Kategori di Beranda
    const catBtns = document.querySelectorAll('.cat-btn');
    catBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            catBtns.forEach(b => b.classList.remove('active'));
            const clickedBtn = e.target;
            clickedBtn.classList.add('active');
            
            // Filter list berdasarkan teks tombol
            renderHomeList(clickedBtn.textContent);
        });
    });

    // Handle Error 3D Model
    const modelViewer = document.getElementById('ar-model-viewer');
    if (modelViewer) {
        modelViewer.addEventListener('error', (error) => {
            console.error('Error loading 3D model. Make sure the URL is correct and CORS is allowed.', error);
        });
    }
});
