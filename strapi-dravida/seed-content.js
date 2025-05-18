const axios = require("axios");

const API_URL = "http://localhost:1337/api";
const EMAIL = "yathish.iitkgp@gmail.com";
const PASSWORD = "Yathish@123";

const levelsData = [
  {
    title: "Basic Vowels",
    order: 1,
    description: "Learn ಅ, ಆ, ಇ, ಈ\n\nಅ (a - 'apple'), ಆ (aa - 'father'), ಇ (i - 'ink'), ಈ (ii - 'eel')",
    items: [
      { letter: "ಅ", hint: "Sounds like 'a' in 'apple'" },
      { letter: "ಆ", hint: "Sounds like 'aa' in 'father'" },
      { letter: "ಇ", hint: "Sounds like 'i' in 'ink'" },
      { letter: "ಈ", hint: "Sounds like 'ee' in 'eel'" },
    ],
  },
  {
    title: "Extended Vowels",
    order: 2,
    description: "Learn ಉ, ಊ, ಋ, ೠ\n\nಉ (u - 'put'), ಊ (uu - 'pool'), ಋ (ru - 'rishi'), ೠ (rū - rarely used, Sanskrit only)",
    items: [
      { letter: "ಉ", hint: "Sounds like 'u' in 'put'" },
      { letter: "ಊ", hint: "Sounds like 'oo' in 'moon'" },
      { letter: "ಋ", hint: "Sounds like 'ri' in 'river' (retroflex)" },
      { letter: "ೠ", hint: "Long form of ಋ, rare in use" },
    ],
  },
  {
    title: "Nasal & Soft Vowels",
    order: 3,
    description: "Learn ಎ, ಏ, ಐ, ಒ\n\nಎ (e - 'red'), ಏ (ee - 'ace'), ಐ (ai - 'ice'), ಒ (o - 'top')",
    items: [
      { letter: "ಎ", hint: "Sounds like 'e' in 'pen'" },
      { letter: "ಏ", hint: "Sounds like 'ay' in 'day'" },
      { letter: "ಐ", hint: "Sounds like 'ai' in 'aisle'" },
      { letter: "ಒ", hint: "Sounds like 'o' in 'top'" },
    ],
  },
  {
    title: "Final Vowels",
    order: 4,
    description: "Learn ಓ, ಔ, ಅಂ, ಅಃ\n\nಓ (oo - 'go'), ಔ (au - 'cow'), ಅಂ (am - nasal), ಅಃ (aha - exhale sound, Sanskrit)",
    items: [
      { letter: "ಓ", hint: "Sounds like 'o' in 'go'" },
      { letter: "ಔ", hint: "Sounds like 'ow' in 'cow'" },
      { letter: "ಅಂ", hint: "Nasalized 'am', like 'um' in 'drum'" },
      { letter: "ಅಃ", hint: "Aspirated 'ah', used in Vedic expressions" },
    ],
  },
  {
    title: "Ka-Varga Consonants",
    order: 5,
    description: "Learn ಕ to ಙ (Velar sounds)\n\nಕ, ಖ, ಗ, ಘ, ಙ — ka, kha, ga, gha, ṅa",
    items: [
      { letter: "ಕ", hint: "Sounds like 'ka' in 'karma'" },
      { letter: "ಖ", hint: "Aspirated 'kha', like 'kha' in 'Khadi'" },
      { letter: "ಗ", hint: "Sounds like 'ga' in 'gum'" },
      { letter: "ಘ", hint: "Aspirated 'gha', like in 'ghat'" },
      { letter: "ಙ", hint: "Nasal 'nga', like 'ng' in 'song'" },
    ],
  },
  {
    title: "Ca-Varga Consonants",
    order: 6,
    description: "Learn ಚ to ಞ (Palatal sounds)\n\nಚ, ಛ, ಜ, ಝ, ಞ — ca, cha, ja, jha, ña",
    items: [
      { letter: "ಚ", hint: "Like 'cha' in 'chap'" },
      { letter: "ಛ", hint: "Aspirated 'chha', like in 'chhan' (Hindi)" },
      { letter: "ಜ", hint: "Like 'ja' in 'jam'" },
      { letter: "ಝ", hint: "Aspirated 'jha', like in 'jharkhand'" },
      { letter: "ಞ", hint: "Nasal 'nya', like 'ny' in 'canyon'" },
    ],
  },
  {
    title: "Ṭa-Varga Consonants",
    order: 7,
    description: "Learn ಟ to ಣ (Retroflex sounds)\n\nಟ, ಠ, ಡ, ಢ, ಣ — ṭa, ṭha, ḍa, ḍha, ṇa",
    items: [
      { letter: "ಟ", hint: "Retroflex 'ṭa', like 'ta' with the tongue curled" },
      { letter: "ಠ", hint: "Aspirated retroflex 'ṭha', strong burst" },
      { letter: "ಡ", hint: "Retroflex 'ḍa', like 'du' in 'dug' (curled tongue)" },
      { letter: "ಢ", hint: "Aspirated retroflex 'ḍha', like in 'dhool'" },
      { letter: "ಣ", hint: "Retroflex nasal 'ṇa', like 'n' in 'burn' (curled)" },
    ],
  },
  {
    title: "Ta-Varga Consonants",
    order: 8,
    description: "Learn ತ to ನ (Dental sounds)\n\nತ, ಥ, ದ, ಧ, ನ — ta, tha, da, dha, na",
    items: [
      { letter: "ತ", hint: "Dental 'ta', like 't' in 'tame'" },
      { letter: "ಥ", hint: "Aspirated dental 'tha', strong 't-ha' sound" },
      { letter: "ದ", hint: "Dental 'da', like 'd' in 'dog'" },
      { letter: "ಧ", hint: "Aspirated dental 'dha', like 'dh' in 'dhobi'" },
      { letter: "ನ", hint: "Dental nasal 'na', like 'n' in 'net'" },
    ],
  },
  {
    title: "Pa-Varga Consonants",
    order: 9,
    description: "Learn ಪ to ಮ (Labial sounds)\n\nಪ, ಫ, ಬ, ಭ, ಮ — pa, pha, ba, bha, ma",
    items: [
      { letter: "ಪ", hint: "Like 'pa' in 'pan'" },
      { letter: "ಫ", hint: "Aspirated 'pha', like 'f' in 'fan' (interchangeable)" },
      { letter: "ಬ", hint: "Like 'ba' in 'bat'" },
      { letter: "ಭ", hint: "Aspirated 'bha', like in 'Bharat'" },
      { letter: "ಮ", hint: "Like 'ma' in 'man'" },
    ],
  },
  {
    title: "Semi-Vowels & Sibilants",
    order: 10,
    description: "Learn ಯ, ರ, ಲ, ವ, ಶ, ಷ, ಸ\n\nಯ (ya), ರ (ra), ಲ (la), ವ (va), ಶ (sha), ಷ (ṣa), ಸ (sa)",
    items: [
      { letter: "ಯ", hint: "Like 'ya' in 'yarn'" },
      { letter: "ರ", hint: "Like 'ra' in 'run'" },
      { letter: "ಲ", hint: "Like 'la' in 'lamp'" },
      { letter: "ವ", hint: "Like 'va' in 'van'" },
      { letter: "ಶ", hint: "Like 'sha' in 'shut'" },
      { letter: "ಷ", hint: "Retroflex 'ṣa', tongue curled — Sanskrit" },
      { letter: "ಸ", hint: "Like 'sa' in 'sun'" },
    ],
  },
  {
    title: "Special Consonants",
    order: 11,
    description: "Learn ಹ, ಳ, ಕ್ಷ, ಜ್ಞ, ಱ\n\nಹ (ha), ಳ (ḷa), ಕ್ಷ (kṣa), ಜ್ಞ (jña), ಱ (ṟa – archaic)",
    items: [
      { letter: "ಹ", hint: "Like 'ha' in 'hat'" },
      { letter: "ಳ", hint: "Retroflex 'ḷa', tongue curled" },
      { letter: "ಕ್ಷ", hint: "Compound 'kṣa', like 'ksha' in 'akshara'" },
      { letter: "ಜ್ಞ", hint: "Compound 'jña', like 'gya' in 'gyan' (Hindi)" },
      { letter: "ಱ", hint: "Compound 'ra'" },
    ],
  },
];

(async () => {
  const loginRes = await axios.post(`${API_URL}/auth/local`, {
    identifier: EMAIL,
    password: PASSWORD,
  });

  const token = loginRes.data.jwt;
  const headers = { Authorization: `Bearer ${token}` };

  const moduleRes = await axios.post(`${API_URL}/modules`, {
    data: { title: "Alphabets" },
  }, { headers });

  // const moduleId = moduleRes.data.data.id;

  // for (const level of levelsData) {
  //   const levelRes = await axios.post(`${API_URL}/levels`, {
  //     data: {
  //       title: level.title,
  //       order: level.order,
  //       description: level.description,
  //       module: moduleId,
  //     },
  //   }, { headers });

  //   const levelId = levelRes.data.data.id;

  //   for (const [itemIndex, item] of level.items.entries()) {
  //     const itemRes = await axios.post(`${API_URL}/item-flashcards`, {
  //       data: {
  //         letter: item.letter,
  //         hint: item.hint,
  //       },
  //     }, { headers });

  //     const itemId = itemRes.data.data.id;

  //     await axios.post(`${API_URL}/level-item-links`, {
  //       data: {
  //         level: levelId,
  //         itemFlashcard: itemId,
  //         order: itemIndex + 1,
  //       },
  //     }, { headers });
  //   }
  // }

  console.log("✅ All content created successfully.");
})();
