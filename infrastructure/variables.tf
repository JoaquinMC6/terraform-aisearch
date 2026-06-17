variable "location" {
  description = "Región de Azure principal donde se desplegará la infraestructura."
  type        = string
  default     = "West Europe"
}

variable "location_functions" {
  description = "Región para Azure Functions. El plan Consumption Linux no está disponible en todas las regiones."
  type        = string
  default     = "West Europe"
}

variable "environment" {
  description = "Entorno de despliegue (dev, pre, pro)."
  type        = string

  validation {
    condition     = contains(["dev", "pre", "pro"], var.environment)
    error_message = "El entorno debe ser dev, pre o pro."
  }
}

variable "project" {
  description = "Nombre corto del proyecto. Se usa como prefijo en los nombres de recursos."
  type        = string
  default     = "ormazabal-ia"
}

variable "tags" {
  description = "Mapa de etiquetas adicionales a aplicar a todos los recursos."
  type        = map(string)
  default     = {}
}


# ─── AI Search ───────────────────────────────────────────────────────────────
variable "search_sku" {
  description = "SKU de Azure AI Search. standard soporta búsqueda semántica/vectorial."
  type        = string
  default     = "standard"
}

# ─── Azure AI Foundry — model deployments ────────────────────────────────────
variable "embedding_model_name" {
  description = "Modelo de embeddings a desplegar en Azure AI Services."
  type        = string
  default     = "text-embedding-3-large"
}

variable "embedding_model_version" {
  description = "Versión del modelo de embeddings (consultar catálogo de AI Foundry)."
  type        = string
  default     = "1"
}

variable "embedding_capacity" {
  description = "Capacidad del despliegue de embeddings en miles de tokens por minuto (TPM)."
  type        = number
  default     = 0
}

variable "chat_model_name" {
  description = "Modelo de chat/completions a desplegar en Azure AI Services."
  type        = string
  default     = "gpt-5.4-nano"
}

variable "chat_model_version" {
  description = "Versión del modelo de chat (consultar catálogo de AI Foundry)."
  type        = string
  default     = "2026-03-17"
}

variable "chat_capacity" {
  description = "Capacidad del despliegue de chat en miles de tokens por minuto (TPM)."
  type        = number
  default     = 0
}


variable "storage_replication" {
  description = "Tipo de replicación del Storage Account de documentos. LRS para dev, GRS para prod."
  type        = string
  default     = "LRS"
}
