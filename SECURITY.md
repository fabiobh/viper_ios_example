# 🔒 Security Best Practices - API Key Management

## ⚠️ Problema: API Keys no Código

Nunca coloque API keys diretamente no código-fonte por estas razões:

1. **Exposição no Controle de Versão**: Qualquer pessoa com acesso ao repositório pode ver a chave
2. **Histórico do Git**: Mesmo se removida depois, a chave permanece no histórico do Git
3. **Repositórios Públicos**: Se o repo for público, sua chave fica exposta para o mundo
4. **Segurança**: Chaves expostas podem ser usadas indevidamente, gerando custos ou problemas

## ✅ Solução Implementada

Este projeto usa **Configuration.plist** para armazenar dados sensíveis de forma segura:

### Estrutura:

```
ios_viper_example/
├── Configuration.plist.example    ← Template versionado no Git
├── Configuration.plist            ← Arquivo real (NÃO versionado)
└── .gitignore                     ← Garante que Configuration.plist não seja commitado
```

### Como Funciona:

1. **Configuration.plist.example**: 
   - Versionado no Git
   - Contém apenas placeholders
   - Serve como template para desenvolvedores

2. **Configuration.plist**:
   - NÃO versionado (está no .gitignore)
   - Contém a API key real
   - Cada desenvolvedor tem sua própria cópia local

3. **NetworkManager.swift**:
   - Lê a API key do Configuration.plist em runtime
   - Valida se a chave foi configurada
   - Fornece mensagem de erro clara se não estiver configurada

## 🚀 Setup para Novos Desenvolvedores

### Opção 1: Script Automático (Recomendado)

```bash
./setup.sh
```

O script irá:
- Copiar Configuration.plist.example para Configuration.plist
- Solicitar sua API key
- Configurar automaticamente

### Opção 2: Manual

```bash
# 1. Copiar o template
cp ios_viper_example/Configuration.plist.example ios_viper_example/Configuration.plist

# 2. Editar o arquivo
# Abra Configuration.plist e substitua YOUR_TMDB_API_KEY pela sua chave real
```

## 🔍 Verificação de Segurança

### Antes de Commitar:

```bash
# Verificar se Configuration.plist está no .gitignore
git check-ignore ios_viper_example/Configuration.plist

# Deve retornar: ios_viper_example/Configuration.plist
# Se não retornar nada, PARE e adicione ao .gitignore!
```

### Verificar Histórico do Git:

```bash
# Verificar se alguma API key foi commitada acidentalmente
git log -p | grep -i "api.*key"
```

## 🛡️ Boas Práticas Adicionais

### 1. Nunca Commite Secrets

❌ **NUNCA faça isso:**
```swift
private let apiKey = "a1b2c3d4e5f6g7h8i9j0"  // ❌ Hardcoded!
```

✅ **SEMPRE faça isso:**
```swift
private let apiKey: String
init() {
    // Ler de arquivo de configuração
    self.apiKey = loadFromConfig()
}
```

### 2. Use .gitignore Corretamente

Sempre adicione arquivos de configuração ao `.gitignore`:

```gitignore
# Configuration files with sensitive data
Configuration.plist
*.plist
!*.plist.example

# Environment files
.env
.env.local

# Secrets
secrets.json
api-keys.txt
```

### 3. Rotação de Chaves

Se uma API key for exposta acidentalmente:

1. **Revogue imediatamente** a chave no TMDB
2. **Gere uma nova** chave
3. **Atualize** seu Configuration.plist local
4. **Limpe o histórico do Git** se necessário:

```bash
# Use git-filter-repo ou BFG Repo-Cleaner
# CUIDADO: Isso reescreve o histórico!
git filter-repo --path Configuration.plist --invert-paths
```

### 4. Ambientes Diferentes

Para projetos maiores, considere ter configurações diferentes:

```
Configuration.Development.plist
Configuration.Staging.plist
Configuration.Production.plist
```

Todos devem estar no `.gitignore`!

## 🏢 Para Equipes

### CI/CD

Em pipelines de CI/CD, use variáveis de ambiente ou secrets managers:

```yaml
# GitHub Actions example
- name: Create Configuration.plist
  run: |
    echo '<?xml version="1.0" encoding="UTF-8"?>' > Configuration.plist
    echo '<plist version="1.0"><dict>' >> Configuration.plist
    echo '<key>TMDB_API_KEY</key>' >> Configuration.plist
    echo "<string>${{ secrets.TMDB_API_KEY }}</string>" >> Configuration.plist
    echo '</dict></plist>' >> Configuration.plist
```

### Onboarding de Novos Desenvolvedores

Inclua no README:

1. Como obter credenciais
2. Como configurar o projeto
3. Onde encontrar documentação de segurança

## 📚 Alternativas Avançadas

Para projetos em produção, considere:

1. **Keychain Services** (iOS)
   - Armazenamento seguro no dispositivo
   - Criptografado pelo sistema

2. **Environment Variables**
   - Configuradas no esquema do Xcode
   - Diferentes por ambiente

3. **Backend Proxy**
   - API key fica no servidor
   - App se comunica com seu backend
   - Backend faz chamadas para TMDB

4. **Secret Management Services**
   - AWS Secrets Manager
   - HashiCorp Vault
   - Azure Key Vault

## ✅ Checklist de Segurança

Antes de fazer push:

- [ ] Configuration.plist está no .gitignore
- [ ] Não há API keys hardcoded no código
- [ ] Configuration.plist.example não contém chaves reais
- [ ] README documenta como configurar
- [ ] Script de setup está funcionando
- [ ] Verificou o histórico do Git

## 🆘 Se Você Expôs uma API Key

1. **Revogue imediatamente** no TMDB
2. **Gere nova chave**
3. **Limpe o histórico do Git** (se já foi commitado)
4. **Notifique a equipe**
5. **Revise processos** para evitar repetição

## 📖 Recursos

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Apple Security Best Practices](https://developer.apple.com/security/)
- [Git Secrets](https://github.com/awslabs/git-secrets)

---

**Lembre-se**: Segurança não é opcional. Proteja suas credenciais! 🔐
