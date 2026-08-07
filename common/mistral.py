import os
import logging

log = logging.getLogger("captcha-solver")

class KeyPool:
    def __init__(self, key_file="common/apikey.txt", max_retries=3, model=None, start_index=0):
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
        if not self.keys:
            return None
        key = self.keys[self.current % self.total]
        self.current += 1
        return key

    def ask(self, image_base64=None, prompt=None, model=None):
        """
        Kompatibilitas dengan pemanggil. Karena Mistral dinonaktifkan,
        kembalikan string kosong agar pemrosesan tetap berjalan tanpa error.
        """
        log.warning("Mistral ask() called but Mistral is disabled. Returning empty string.")
        return ""  # <-- string kosong, bukan None atau dict

# Singleton
_key_pool = None

def get_key_pool():
    global _key_pool
    if _key_pool is None:
        _key_pool = KeyPool()
    return _key_pool
