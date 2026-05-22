document.addEventListener('DOMContentLoaded', () => {
  const STORAGE_KEY = 'reading-list-likes';
  let likes = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');

  document.querySelectorAll('.like-button').forEach(btn => {
    if (likes.includes(btn.dataset.id)) {
      btn.classList.add('liked');
    }
  });

  document.querySelectorAll('.like-button').forEach(btn => {
    btn.addEventListener('click', () => {
      const id = btn.dataset.id;
      btn.classList.toggle('liked');
      if (btn.classList.contains('liked')) {
        if (!likes.includes(id)) likes.push(id);
      } else {
        likes = likes.filter(x => x !== id);
      }
      localStorage.setItem(STORAGE_KEY, JSON.stringify(likes));
    });
  });
});
