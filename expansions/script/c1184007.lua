--饮食艺术·曲奇人形
function c1184007.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184007,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1184007)
	e1:SetTarget(c1184007.tg1)
	e1:SetOperation(c1184007.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c1184007.cost2)
	e2:SetTarget(c1184007.tg2)
	e2:SetOperation(c1184007.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184007.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c1184007.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1184007.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1184007.tfilter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1184007.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c1184007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
--
function c1184007.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1184007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1184007.op2(e,tp,eg,ep,ev,re,r,rp)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetDescription(aux.Stringid(1184007,2))
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2_1:SetCountLimit(1)
	e2_1:SetLabel(Duel.GetTurnCount())
	e2_1:SetCondition(c1184007.con2_1)
	e2_1:SetOperation(c1184007.op2_1)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e2_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e2_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2_1,tp)
end
function c1184007.cfilter2_1(c,e,tp)
	return c:IsSetCard(0x3e12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1184007.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(c1184007.cfilter2_1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c1184007.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1184007)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.SelectMatchingCard(tp,c1184007.cfilter2_1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if mg:GetCount()>0 then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--