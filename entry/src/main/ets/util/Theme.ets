// 全局主题配置，集中管理颜色与常用尺寸
type ColorValue = string | Color

interface ThemeConfig {
  primary: ColorValue
  primaryDark: ColorValue
  accent: ColorValue
  background: ColorValue
  card: ColorValue
  textPrimary: Color
  textSecondary: string
  success: ColorValue
  danger: ColorValue
  divider: string
  shadowColor: string
}

interface SpacingConfig {
  page: number
  cardRadius: number
  cardPadding: number
}

interface TypographyConfig {
  title: number
  subtitle: number
  body: number
  caption: number
}

export const Theme: ThemeConfig = {
  primary: '#FFE20D',
  primaryDark: '#EBB400',
  accent: '#EB5E1A',
  background: '#F5F6FA',
  card: '#FFFFFF',
  textPrimary: Color.Black,
  textSecondary: '#6B6C70',
  success: '#4BB0C4',
  danger: '#FF6B6B',
  divider: '#E9E9EB',
  shadowColor: '#1A000000'
}

export const Spacing: SpacingConfig = {
  page: 20,
  cardRadius: 16,
  cardPadding: 16
}

export const Typography: TypographyConfig = {
  title: 22,
  subtitle: 18,
  body: 14,
  caption: 12
}
