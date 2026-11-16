import { Platform } from 'react-native';

export const colors = {
  paper: '#F7F1E7',
  surface: '#FFFCF6',
  inset: '#EEE3D2',
  ink: '#30271F',
  muted: '#6C5B4C',
  accent: '#8F3926',
  onAccent: '#FFFFFF',
  border: '#B9A48C',
  error: '#9C2920',
  success: '#385B37',
} as const;

export const headingFont = Platform.select({ android: 'serif', ios: 'Georgia', default: 'serif' });
