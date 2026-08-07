import os
import logging

log = logging.getLogger("captcha-solver")

class KeyPool:
    def __init__(self, key_file="common/apikey.txt", max_retries=3, model=None, start_index=0):
        """
        Inisialisasi KeyPool untuk Mistral API keys.
        
        Args:
            key_file (str): Path ke file yang berisi API keys (satu per baris).
            max_retries (int): Jumlah maksimum percobaan (disimpan untuk kompatibilitas).
            model (str): Nama model Mistral (disimpan untuk kompatibilitas).
            start_index (int): Indeks awal untuk round-robin (disimpan untuk kompatibilitas).
        """
        self.keys = []
        self.current = start_index
        self.max_retries = max_retries
        self.model = model
        self.start_index = start_index
        
        try:
            if os.path.exists(key_file):
                with open(key_file, "r") as f:
                    for line in f:
                        line = line.strip()
                        if line:
                            self.keys.append(line)
                if self.keys:
                    log.info(f"Mistral KeyPool loaded {len(self.keys)} keys")
                else:
                    log.warning("Mistral KeyPool: file exists but no keys found")
            else:
                log.warning(f"Mistral KeyPool: {key_file} not found, Mistral vision will be disabled")
        except Exception as e:
            log.error(f"Mistral KeyPool init error: {e}")
        self.total = len(self.keys)

    def get_key(self):
        """Ambil satu API key secara round-robin."""
        if not self.keys:
            return None
        key = self.keys[self.current % self.total]
        self.current += 1
        return key

    def ask(self, prompt, image_base64=None, model=None):
        """
        Metode untuk kompatibilitas dengan panggilan yang mengharapkan ask().
        Karena kita tidak punya kunci Mistral, metode ini selalu mengembalikan None
        dan mencatat peringatan.
        """
        log.warning("Mistral ask() called but Mistral is disabled (no API keys or disabled).")
        return None


# Singleton instance, load from default location
_key_pool = None

def get_key_pool():
    global _key_pool
    if _key_pool is None:
        _key_pool = KeyPool()
    return _key_pool
