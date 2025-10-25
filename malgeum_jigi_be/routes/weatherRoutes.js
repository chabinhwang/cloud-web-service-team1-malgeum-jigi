import express from 'express';
import { getCurrentAirQuality } from '../controllers/weatherController.js';

const router = express.Router();

router.get('/current', getCurrentAirQuality);
//router.get('/today', getTodayEnvironment);

export default router;