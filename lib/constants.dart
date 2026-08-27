import 'package:flutter/material.dart';

const String host = 'https://dummyjson.com';

/// ---------------------------------------------------------------------------
/// LOOP — design system
/// ---------------------------------------------------------------------------
/// A modern, minimal social app. Brand colour is teal (#0D9488) with an
/// emerald accent. The palette is deliberately restrained: one accent, a small
/// set of neutrals, generous whitespace, soft rounded corners, near-flat cards.
///
/// [loopDarkMode] is flipped by ThemeProvider.toggleTheme(); because the root
/// MaterialApp listens to that provider, toggling rebuilds the tree and every
/// widget re-reads the getters below.
bool loopDarkMode = false;

// Brand ---------------------------------------------------------------------
const String kAppName = 'Loop';

/// Generic placeholder avatar used across the app wherever a real profile
/// picture isn't available.
const String kGenericAvatar = 'assets/images/generic_avatar.png';
const Color LOOP_TEAL = Color(0xFF0D9488); // primary brand
const Color LOOP_TEAL_DARK = Color(0xFF0F766E);
const Color LOOP_EMERALD = Color(0xFF10B981); // accent / success
const Color LOOP_ON_BRAND = Color(0xFFFFFFFF);
const Color LOOP_DANGER = Color(0xFFEF4444);

// Radii / spacing scale (used everywhere for consistency)
const double kRadiusSm = 10;
const double kRadiusMd = 16;
const double kRadiusLg = 24;
const double kGap = 16;

// Adaptive neutrals ------------------------------------------------------------

/// App/page background.
Color get LOOP_BG =>
    loopDarkMode ? const Color(0xFF0B0F0E) : const Color(0xFFF6F7F6);

/// Card / sheet surface, sits just above the background.
Color get LOOP_SURFACE =>
    loopDarkMode ? const Color(0xFF161A19) : const Color(0xFFFFFFFF);

/// Subtle raised fill (chips, inputs, comment bubbles).
Color get LOOP_SUBTLE =>
    loopDarkMode ? const Color(0xFF202624) : const Color(0xFFEEF1F0);

/// Hairline borders / dividers.
Color get LOOP_BORDER =>
    loopDarkMode ? const Color(0xFF2A312F) : const Color(0xFFE3E7E6);

/// Primary text.
Color get LOOP_TEXT =>
    loopDarkMode ? const Color(0xFFECEFEE) : const Color(0xFF10201D);

/// Muted / secondary text.
Color get LOOP_MUTED =>
    loopDarkMode ? const Color(0xFF9AA5A2) : const Color(0xFF6B7280);

/// Brand accent adapted for the current surface.
Color get LOOP_ACCENT =>
    loopDarkMode ? const Color(0xFF2DD4BF) : LOOP_TEAL;

// ---------------------------------------------------------------------------
// Backwards-compatible aliases.
// The rest of the codebase (and the classmate's original) referenced FB_*
// tokens. Keeping thin aliases avoids touching every widget while the visual
// identity is now fully "Loop".
// ---------------------------------------------------------------------------
bool get fbDarkMode => loopDarkMode;
set fbDarkMode(bool v) => loopDarkMode = v;

const Color FB_SECONDARY = LOOP_EMERALD;
const Color FB_LIGHT_PRIMARY = LOOP_TEAL;
const Color FB_TEXT_COLOR_WHITE = LOOP_ON_BRAND;

Color get FB_SURFACE => LOOP_BG;
Color get FB_CARD => LOOP_SURFACE;
Color get FB_PRIMARY => LOOP_ACCENT;
Color get FB_DARK_PRIMARY => LOOP_ACCENT;
Color get FB_TEXT_PRIMARY => LOOP_TEXT;
Color get FB_TEXT_COLOR_GREY => LOOP_MUTED;
Color get FB_TEXT_COLOR_DARKGREY => LOOP_MUTED;
