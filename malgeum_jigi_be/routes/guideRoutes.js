import express from 'express';
import { getVentilationScore, getOutdoorGuide, getApplianceGuide, getWeeklyGuide } from '../controllers/guideController.js';

const router = express.Router();

router.get('/ventilation', getVentilationScore);
router.get('/outdoor', getOutdoorGuide);
router.get('/appliances', getApplianceGuide);
router.get('/weekly', getWeeklyGuide);

export default router;