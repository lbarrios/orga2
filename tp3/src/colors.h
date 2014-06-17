#ifndef __COLORS_H__
#define __COLORS_H__

/* Definicion de colores */
/* -------------------------------------------------------------------------- */
#define C_FG_BLACK              (0x0)
#define C_FG_BLUE               (0x1)
#define C_FG_GREEN              (0x2)
#define C_FG_CYAN               (0x3)
#define C_FG_RED                (0x4)
#define C_FG_MAGENTA            (0x5)
#define C_FG_BROWN              (0x6)
#define C_FG_LIGHT_GREY         (0x7)
#define C_FG_DARK_GREY          (0x8)
#define C_FG_LIGHT_BLUE         (0x9)
#define C_FG_LIGHT_GREEN        (0xA)
#define C_FG_LIGHT_CYAN         (0xB)
#define C_FG_LIGHT_RED          (0xC)
#define C_FG_LIGHT_MAGENTA      (0xD)
#define C_FG_LIGHT_BROWN        (0xE)
#define C_FG_WHITE              (0xF)

#define C_BG_BLACK              (0x0 << 4)
#define C_BG_BLUE               (0x1 << 4)
#define C_BG_GREEN              (0x2 << 4)
#define C_BG_CYAN               (0x3 << 4)
#define C_BG_RED                (0x4 << 4)
#define C_BG_MAGENTA            (0x5 << 4)
#define C_BG_BROWN              (0x6 << 4)
#define C_BG_LIGHT_GREY         (0x7 << 4)

#define C_BLINK                 (0x8 << 4)

#define COLOR_PASTO (C_FG_GREEN + C_BG_GREEN)
#define COLOR_INICIAL (C_FG_WHITE + C_BG_LIGHT_GREY)
#define COLOR_PISADO (C_FG_BLACK + C_BG_LIGHT_GREY)
#define COLOR_SUPERPUESTO (C_FG_BLACK + C_BG_BROWN)
#define COLOR_MINA (C_FG_WHITE + C_BG_BLACK)
#define COLOR_MISIL (C_FG_RED + C_BG_CYAN)
#define COLOR_MUERTO (C_FG_WHITE + C_BG_RED)

#endif /* !__COLORS_H__ */
