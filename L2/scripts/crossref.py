import os
import json
import urllib.request
import urllib.parse
import time

DATA_FOLDER = "./data"
OUTPUT_FOLDER = "./crossref"

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

def get_crossref_data(doi, max_retries=3):
    encoded_doi = urllib.parse.quote(doi, safe="")
    url = f"https://api.crossref.org/works/{encoded_doi}"

    for attempt in range(1, max_retries + 1):
        try:
            with urllib.request.urlopen(url, timeout=30) as response:
                return json.loads(response.read().decode("utf-8"))

        except Exception as e:
            print(f"Intento {attempt}/{max_retries} falló para DOI {doi}: {e}")

            if attempt < max_retries:
                wait_time = attempt * 5
                print(f"Esperando {wait_time} segundos antes de reintentar...")
                time.sleep(wait_time)
            else:
                print(f"No se pudo obtener información para DOI: {doi}")
                return None


for file_name in os.listdir(DATA_FOLDER):
    if not file_name.endswith(".json"):
        continue

    file_path = os.path.join(DATA_FOLDER, file_name)

    with open(file_path, "r") as f:
        data = json.load(f)

    for item in data.get("collection", []):
        doi = item.get("rel_doi")

        if not doi:
            continue

        safe_doi = doi.replace("/", "_")
        output_file = os.path.join(OUTPUT_FOLDER, f"{safe_doi}.json")

        # Evita reprocesar DOIs ya descargados
        if os.path.exists(output_file):
            print(f"Ya existe, se omite: {output_file}")
            continue

        print(f"Procesando DOI: {doi}")

        crossref_data = get_crossref_data(doi, max_retries=3)

        if crossref_data:
            with open(output_file, "w") as out:
                json.dump(crossref_data, out, indent=2)

            print(f"Guardado en: {output_file}")

        time.sleep(1)

print("Proceso completado")