"""
Sistema de Calculadora Agrícola FarmTech Solutions
Versão: 1.0
"""

import os
import csv
import subprocess
import platform
from typing import Callable

# Cálculos de área
def area_of_circle(radius: float) -> float:
    """Calcula área do terreno circular"""
    return 3.14159 * (radius ** 2)

def area_of_rectangle(length: float, width: float) -> float:
    """Calcula área do terreno retangular"""
    return length * width

def area_of_square(side: float) -> float:
    """Calcula área do terreno quadrado"""
    return side ** 2

# Cálculos de sementes
def corn_seeds_amount(area: float) -> float:
    """Calcula quantidade de sementes de milho (7.32 sementes/m²)"""
    return area * 7.32

def soy_seeds_amount(area: float) -> float:
    """Calcula quantidade de sementes de soja (30.0 sementes/m²)"""
    return area * 30.0

def registrar_area_csv(area: float, cultura: str) -> None:
    """Registra área e cultura no arquivo CSV"""
    arquivo = "todas_areas.csv"
    existe = os.path.isfile(arquivo)
    
    with open(arquivo, mode="a", newline="") as file:
        writer = csv.writer(file)
        if not existe:
            writer.writerow(["Cultura", "Area"])
        writer.writerow([cultura, area])

def agricultural_culture(area: float, exit: Callable, home: Callable) -> None:
    """Menu de seleção de cultura e cálculo de sementes"""
    os.system('cls' if os.name == 'nt' else 'clear')
    print("===== Calculadora de insumos ===== \n")
    print("Escolha a cultura a ser plantada:\n")
    print("1. Milho")
    print("2. Soja")
    print("3. Voltar")
    print("4. Sair \n")

    agricultutal_choice = input("Escolha a opção: ")
    os.system('cls' if os.name == 'nt' else 'clear')

    if agricultutal_choice == "1":
        print("São necessários {:.2f} sementes de milho para plantar em seus {:.2f} metros quadrados. \n".format(corn_seeds_amount(area), area))
        registrar_area_csv(area, "Milho")
        input("Pressione qualquer tecla para prosseguir...")
        home()
    elif agricultutal_choice == "2":
        print("São necessários {:.2f} sementes de soja para plantar em seus {:.2f} metros quadrados. \n".format(soy_seeds_amount(area), area))
        registrar_area_csv(area, "Soja")
        input("Pressione qualquer tecla para prosseguir...")
        home()
    elif agricultutal_choice == "3":
        home()
        print("Voltando para o menu principal...\n")
    elif agricultutal_choice == "4":
        exit()
        print("Programa finalizado.\n")
    else:    
        print("Opção inválida. Por favor, tente novamente \n")

def agricultural_program(exit: Callable) -> None:
    """Menu principal do programa de cálculo de insumos"""
    is_agricultural_program_active = True
    while is_agricultural_program_active == True:
        os.system('cls' if os.name == 'nt' else 'clear')
        print("===== Calculadora de insumos ===== \n")
        print("Qual o formato do seu terreno:\n")
        print("1. Circular")
        print("2. Retângulo")
        print("3. Quadrado")
        print("4. Voltar")
        print("5. Sair \n")

        agricultutal_choice = input("Escolha a opção: ")
        area = 0

        def exit_agricultural():
            exit()
            nonlocal is_agricultural_program_active
            is_agricultural_program_active = False

        def home():
            nonlocal is_agricultural_program_active
            is_agricultural_program_active = False

        if agricultutal_choice == "1":
            radius = float(input("Digite o raio do terreno: "))
            area = area_of_circle(radius)
            agricultural_culture(area, exit_agricultural, home)
        elif agricultutal_choice == "2":
            length = float(input("Digite o comprimento do terreno: "))
            width = float(input("Digite a largura do terreno: "))
            area = area_of_rectangle(length, width)
            agricultural_culture(area, exit_agricultural, home)
        elif agricultutal_choice == "3":
            side = float(input("Digite o lado do terreno: "))
            area = area_of_square(side)
            agricultural_culture(area, exit_agricultural, home)
        elif agricultutal_choice == "4":
            is_agricultural_program_active = False
            print("Voltando para o menu principal...")
        elif agricultutal_choice == "5": 
            is_agricultural_program_active = False
            exit()
        else:
            print("Opção inválida. Por favor, tente novamente.")

def call_statistics_program() -> None:
    """Executa análise estatística usando R"""
    if not os.path.isfile("todas_areas.csv"):
        print("\nAntes de exibir os dados é necessario fornecer os dados a calculadora de insumos.\n")
    else:
        print("Executando calculadora estatística em R...")
        try:
            r_script = "calculadora_estatistica.R"
            if platform.system() == "Windows":
                # Busca Rscript.exe
                r_paths = [
                    r"C:\Program Files\R\R-4.2.0\bin\Rscript.exe",
                    r"C:\Program Files\R\R-4.1.0\bin\Rscript.exe",
                    r"C:\Program Files\R\R-4.0.0\bin\Rscript.exe"
                ]
                rscript_path = None
                for path in r_paths:
                    if os.path.exists(path):
                        rscript_path = path
                        break
                if rscript_path is None:
                    print("Erro: Não foi possível encontrar o Rscript.exe. Certifique-se de que o R está instalado.")
                    return
                subprocess.run([rscript_path, r_script], check=True)
            else:
                subprocess.run(["Rscript", r_script], check=True)
        except Exception as e:
            print("Erro ao executar o script R:", e)

def call_wether_program() -> None:
    """Executa análise climatológica usando R"""
    try:
        r_script = "api_clima.R"
        if platform.system() == "Windows":
            # Busca Rscript.exe
            r_paths = [
                r"C:\Program Files\R\R-4.2.0\bin\Rscript.exe",
                r"C:\Program Files\R\R-4.1.0\bin\Rscript.exe",
                r"C:\Program Files\R\R-4.0.0\bin\Rscript.exe"
            ]
            rscript_path = None
            for path in r_paths:
                if os.path.exists(path):
                    rscript_path = path
                    break
            if rscript_path is None:
                print("Erro: Não foi possível encontrar o Rscript.exe. Certifique-se de que o R está instalado.")
                return
            subprocess.run([rscript_path, r_script], check=True)
        else:
            subprocess.run(["Rscript", r_script], check=True)
    except Exception as e:
        print("Erro ao executar o script R:", e)

# Loop principal
is_global_program_active = True
while is_global_program_active == True:
    print("\n===== Bem vindo à calculadora da Startup FarmTech Solutions ===== \n")
    print("Selecione a opção desejada:")
    print("1. Calcular insumos")
    print("2. Gerar estatísticas")
    print("3. Climatologia")
    print("4. Sair")

    choice = input("Escolha a opção: ")
    if choice == "1":
        def exit_program():
            global is_global_program_active
            is_global_program_active = False
            print("Programa finalizado.")
        agricultural_program(exit_program)

    elif choice == "2":
        call_statistics_program()
    elif choice == "3":
        print("")
        call_wether_program()
    elif choice == "4":
        is_global_program_active = False
        print("Calculadora finalizada.")
    else:
        print("Opção inválida. Tente novamente.")
