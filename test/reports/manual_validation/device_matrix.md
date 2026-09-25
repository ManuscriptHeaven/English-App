# Kids English Adventure — Physical Device Matrix

## Hardware Targets & Evaluation Scope

To ensure comprehensive real-world compatibility, manual testing covers four distinct hardware categories representing the diverse Android ecosystem used by children and families.

---

## 1. Target Hardware Profiles

| Profile Category | Representative Device Model | Form Factor | Display Resolution & Density | Android OS Version | RAM / Hardware Tier | Primary Evaluation Focus | Validation Method |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Device A: Small Phone** | Xiaomi Redmi 9A / Samsung Galaxy A03 Core | Compact Phone | $720 \times 1600\text{ px}$ (~270 dpi, $360\text{ dp}$ width) | Android 11 (Go Edition) / 12 | 2 GB RAM (Low-Tier) | UI clipping, touch target size, keyboard overlap, animation frame drops, low-memory background kills | Physical Hardware |
| **Device B: Standard Phone (Reference)** | Google Pixel 7a / Samsung Galaxy A54 | Standard Phone | $1080 \times 2400\text{ px}$ (~412 dpi, $392\text{ dp}$ width) | Android 14 / 15 | 8 GB RAM (Mid-Tier) | Core reference experience, speech recognition fidelity, transition smoothness, standard battery drain | Physical Hardware |
| **Device C: Large Phone** | Google Pixel 8 Pro / Samsung Galaxy S23 Ultra | Large Flagship | $1344 \times 2992\text{ px}$ (~489 dpi, $430\text{ dp}$ width) | Android 14 / 15 | 12 GB RAM (High-Tier) | Excessive whitespace, button reachability for small hands, asset sharpness at ultra-high resolution | Physical Hardware |
| **Device D: Tablet** | Lenovo Tab M10 / Samsung Galaxy Tab A9 | 10.1" Tablet | $1920 \times 1200\text{ px}$ (~224 dpi, $800\text{ dp}$ width) | Android 13 | 4 GB RAM (Tablet) | Wide-screen content scaling, illustration balance, two-handed child ergonomics, landscape orientation | Physical Tablet / Emulated Fallback |

---

## 2. Environmental & Connectivity Test States

Each device is evaluated under four distinct operational configurations:

1. **Online (High Speed)**: Wi-Fi 5/6 connection with low latency ($<30\text{ ms}$).
2. **Constrained / Flaky**: Emulated 3G / throttled mobile data ($250\text{ kbps}$ with 5% packet loss).
3. **Completely Offline**: Airplane mode enabled before app launch.
4. **Mid-Session Disconnect**: Wi-Fi toggled off during an active interactive learning session.

---

## 3. Peripheral & Audio Hardware Configurations

1. **Internal Hardware**: Built-in phone speaker and bottom-firing microphone.
2. **Wired Headset**: $3.5\text{ mm}$ audio jack headset with in-line microphone.
3. **Bluetooth Audio**: Wireless earbuds / external Bluetooth speaker (A2DP / HFP profiles) with connection toggling during playback.
4. **Muted Device**: System media volume set to 0, validating that visual cues and Pip bubbles convey all critical instructions without audio dependence.
