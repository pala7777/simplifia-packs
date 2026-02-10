# SIMPLIFIA Packs

📦 Repositório oficial de packs do SIMPLIFIA.

## Estrutura

```
packs/
├── base/           # SIMPLIFIA Base (automações universais)
├── whatsapp/       # Pack WhatsApp Negócios
├── freelancers/    # Pack Freelancers
├── criadores/      # Pack Criadores
├── ecommerce/      # Pack E-commerce
└── imobiliario/    # Pack Imobiliário

manifest.json       # Registry de versões
```

## Instalar um Pack

Usando o [SIMPLIFIA Installer](https://github.com/pala7777/simplifia-installer):

```bash
simplifia install whatsapp
```

## Criar um Release

1. Atualizar versão no `pack.json`
2. Criar tag: `git tag pack-whatsapp-v1.0.1`
3. Push: `git push origin pack-whatsapp-v1.0.1`

A GitHub Action automaticamente:
- Cria ZIP do pack
- Calcula SHA256
- Publica release
- Atualiza `manifest.json`

## Estrutura de um Pack

```
packs/<pack_id>/
├── pack.json           # Metadados e config
├── workflows/          # Workflows executáveis (YAML)
├── rules/              # Regras e configs (JSON)
├── assets/             # Templates, quick replies
├── samples/            # Dados de teste
└── migrations/         # SQLite migrations
```

### pack.json

```json
{
  "id": "whatsapp",
  "name": "Pack WhatsApp Negócios",
  "version": "1.0.0",
  "requires": ["base>=1.0.0"],
  "install": {
    "copy_to": {
      "workflows": "~/.openclawd/workflows/simplifia/whatsapp",
      "rules": "~/.openclawd/rules/simplifia/whatsapp",
      "assets": "~/.openclawd/assets/simplifia/whatsapp"
    },
    "db": {
      "type": "sqlite",
      "path": "~/.simplifia/state.db",
      "migrations": ["migrations/sqlite_init.sql"]
    }
  }
}
```

## License

MIT
