import { z } from 'zod';

export const IncidentInputSchema = z.object({
  source: z.string(),
  type: z.enum(['UAV', 'AIR_ALERT', 'EXPLOSION', 'JAMMING', 'OTHER']),
  severity: z.enum(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']),
  lat: z.number().min(-90).max(90),
  lng: z.number().min(-180).max(180),
  radius_m: z.number().int().positive().optional(),
  heading_deg: z.number().int().min(0).max(360).optional(),
  speed_kmh: z.number().int().nonnegative().optional(),
  occurred_at: z.string().datetime(),
  raw: z.any().optional()
});

export type IncidentInput = z.infer<typeof IncidentInputSchema>;
