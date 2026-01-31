const texts = {
  en: {
    welcome: "Universal entry point to knowledge, science, culture and future.",
    terrapedia: "Terrapedia is a living, emergent knowledge space.",
    living_index: "Living Index is the DNA map of Terra.",
    qdna: "QDNA encodes meaning beyond linear storage.",
    institute: "Fractal Metascience Institute — governance of meaning."
  },
  ru: {
    welcome: "Универсальный вход в знания, науку, культуру и будущее.",
    terrapedia: "Террапедия — живая эмерджентная система знаний.",
    living_index: "Living Index — ДНК Терры.",
    qdna: "QDNA кодирует смысл вне линейного хранения.",
    institute: "Институт Фрактальной Метанауки — управление смыслом."
  },
  uz: {
    welcome: "Bilim, fan, madaniyat va kelajak uchun universal kirish.",
    terrapedia: "Terrapedia — tirik bilim makoni.",
    living_index: "Living Index — Terra DNKsi.",
    qdna: "QDNA ma'noni chiziqli bo‘lmagan holda saqlaydi.",
    institute: "Fraktal Metafan Instituti — ma'no boshqaruvi."
  },
  de: {
    welcome: "Universeller Einstieg in Wissen, Wissenschaft und Zukunft.",
    terrapedia: "Terrapedia ist ein lebendiger Wissensraum.",
    living_index: "Living Index ist die DNA von Terra.",
    qdna: "QDNA kodiert Bedeutung jenseits linearer Speicherung.",
    institute: "Institut für Fraktale Metawissenschaft."
  }
};

let currentLang = "en";

function setLang(l) {
  currentLang = l;
  document.getElementById("welcome").innerText = texts[l].welcome;
  document.getElementById("node").innerText = "";
}

function openNode(key) {
  document.getElementById("node").innerText = texts[currentLang][key];
}

setLang("en");
