# 🕌 قلب القرآن (The Quran Heart)

![App Banner](assets/banner_placeholder.png)

**The Quran Heart** is a beautifully designed Islamic application aimed at helping Muslims track their Quran memorization progress through an innovative and interactive visual interface.

## 🌟 Key Features

* **❤️ Interactive Heart Map**:
  * A stunning visualization of all 114 Surahs arranged in a concentric, heart-shaped constellation.
  * Uses advanced **Arc-Length Parameterization** to ensure perfect, uniform spacing of Surahs.
  * **Golden Nodes**: Memorized Surahs glow in gold and connect to form a shining mesh.
* **📊 Memorization Tracking**:
  * Simple tap-to-toggle interface to mark Surahs as memorized.
  * Real-time progress counter (e.g., "15 / 114").
  * **Data Persistence**: Your progress is saved locally and retained across app restarts.
* **🎨 Premium Islamic Aesthetic**:
  * "Night (Noor)" Theme: Deep Midnight Blue background with Gold accents (`#D4AF37`) and White text.
  * Static Geometric Islamic Background for a serene experience.
  * Smooth "Heartbeat" animation for the central visual.
* **🎉 Encouragement**:
  * Celebratory particle effects when you complete a new Surah.
  * Motivational visual feedback as the heart fills with light.

## 📐 Technical Highlights

* **Flutter & Dart**: Built for high performance and smooth animations.
* **Custom Painters**:
  * `HeartMeshPainter`: Draws the dynamic connections between memorized Surahs.
  * `IslamicPatternPainter`: Renders the geometric background procedurally (no heavy assets).
* **Mathematical Layout**:
  * The heart shape is generated using a **Concentric Parametric Equation** ($x = 16 \sin^3 t$).
  * Nodes are distributed using **Numerical Arc-Length Integration** to solve clustering issues.

## 🚀 Getting Started

1. **Clone the repository**:

    ```bash
    git clone https://github.com/yourusername/quran-heart-app.git
    ```

2. **Install dependencies**:

    ```bash
    flutter pub get
    ```

3. **Run the app**:

    ```bash
    flutter run
    ```

## 📂 Project Structure

* `lib/screens/heart_view.dart`: The core visual component containing the heart logic.
* `lib/screens/islamic_painter.dart`: The background pattern generator.
* `lib/providers/quran_provider.dart`: State management for Surah data.
* `lib/data/heart_data.dart`: The pre-calculated coordinates for the 114 Surahs.

## 🛡️ License

This project is open-source and available for educational and personal use.

---
Developed with ❤️ for the Ummah. by "Hossam Ezzat Harera"
