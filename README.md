# Bucket do Scoop do InfiniTypes

Manifesto do [Scoop](https://scoop.sh) para instalar e atualizar o [InfiniTypes](https://github.com/HelioVieiraSilvaJr/InfiniTypes) no Windows pelo terminal.

## Instalar

No PowerShell, com o Scoop instalado:

```powershell
scoop bucket add infinitypes https://github.com/HelioVieiraSilvaJr/scoop-bucket
scoop install infinitypes
```

Requer Windows 10 ou 11. O Scoop escolhe sozinho o pacote x64 ou ARM64 e cria o atalho **InfiniTypes** no menu Iniciar.

O app ainda não é assinado, então o SmartScreen pode avisar na primeira abertura: **Mais informações → Executar assim mesmo**. Na primeira vez, cole a sua chave da API da Anthropic nas Preferências.

## Atualizar

Feche o InfiniTypes antes, pelo ícone perto do relógio: o Scoop não atualiza um app aberto.

```powershell
scoop update
scoop update infinitypes
```

O histórico, as preferências e o modelo de voz ficam em `%LOCALAPPDATA%\InfiniTypes` e passam de uma versão para a outra.

## Desinstalar

```powershell
scoop uninstall infinitypes
```

O Scoop não apaga os dados do app. Para apagá-los, remova a pasta `%LOCALAPPDATA%\InfiniTypes` e, no **Gerenciador de Credenciais do Windows**, a credencial `InfiniTypes/anthropic-api-key`.

## Como o manifesto se atualiza

O workflow [Atualizar o InfiniTypes](.github/workflows/update.yml) confere a cada 6 horas se saiu uma versão nova com os `.zip` do Windows, inclusive as de pré-lançamento, e atualiza a versão, os endereços e os hashes em [`bucket/infinitypes.json`](bucket/infinitypes.json). Para atualizar na hora, rode o workflow na aba **Actions**.

O GitHub pausa os workflows agendados de repositórios sem atividade por 60 dias. Se isso acontecer, reative o workflow na aba **Actions**.
