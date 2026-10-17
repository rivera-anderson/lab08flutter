# Laboratorio 08 - App Móvil en Flutter (Estilo iOS)

Aplicación desarrollada en Flutter con diseño inspirado en la guía de diseño de Apple (iOS Human Interface Guidelines) y arquitectura modular por pantallas según el esquema solicitado en el laboratorio.

---

## 📱 Pantallas Implementadas

1. **LOGIN (`login_screen.dart`)**:
   - Campos: **Correo** y **Password** con validación interactiva.
   - Botón: **INGRESAR** con feedback de carga y animación de transición.
   - Datos demo precargados para pruebas rápidas.

2. **MENÚ (`menu_screen.dart`)**:
   - Tarjetas agrupadas con las 4 opciones requeridas:
     - **Registrar productos** ➔ Abre pantalla de registro.
     - **Listar productos** ➔ Abre catálogo de productos.
     - **Perfil** ➔ Abre pantalla de usuario.
     - **Logout** ➔ Muestra alerta de confirmación estilo `CupertinoAlertDialog` y redirige al Login.

3. **REGISTRAR PRODUCTOS (`add_product_screen.dart`)**:
   - Campos: **Nombre del producto**, **Descripción**, **Precio** (con prefijo en Soles S/).
   - Botón: **GUARDAR** que inserta reactivamente el producto en el catálogo global.

4. **LISTAR PRODUCTOS (`list_products_screen.dart`)**:
   - Muestra los productos base del laboratorio:
     - *Laptop* (S/ 2500)
     - *Mouse* (S/ 80)
     - *Teclado* (S/ 120)
     - *Monitor* (S/ 900)
   - Barra de búsqueda interactiva en tiempo real.
   - Modal inferior (`CupertinoModalPopup`) con detalle completo del producto al presionar cada ítem.
   - Capacidad de deslizar (`Dismissible`) para eliminar ítems con confirmación visual en rojo iOS.

5. **PERFIL (`profile_screen.dart`)**:
   - Avatar iOS con gradiente e iniciales.
   - Muestra **Nombre** (*Juan Pérez*), **Correo** (*juan@email.com*) y **Teléfono** (*987 654 321*).
   - Botón: **EDITAR PERFIL** que abre un formulario flotante interactivo para actualizar los datos en tiempo real.

---

## 🚀 Códigos y Técnicas Avanzadas (No explicadas en clase)

1. **Gestor de Estado Singleton con `ChangeNotifier` (`app_state.dart`)**:
   - Permite que al guardar un producto en *Registrar Productos*, aparezca inmediatamente en *Listar Productos* sin requerir paquetes externos pesados.
   
2. **Uso de `ListenableBuilder`**:
   - Escucha cambios reactivos del estado y reconstruye únicamente la lista, optimizando el rendimiento y los frames por segundo (60/120 fps).

3. **Navegación Nativa con `CupertinoPageRoute`**:
   - Utiliza transiciones de deslizamiento y retroceso nativo propio del sistema operativo iOS.

4. **Alertas y Hojas Modales Nativas (`CupertinoAlertDialog` y `showCupertinoModalPopup`)**:
   - Réplica idéntica de la experiencia visual de iOS para confirmaciones de cierre de sesión y edición rápida.

---

## ▶️ Instrucciones para Ejecutar la App

Para probar la app en tu navegador web o en Windows Desktop:

```bash
cd lab08_app

# Ejecutar en Google Chrome
flutter run -d chrome

# O ejecutar en Windows Desktop
flutter run -d windows
```
