--彗星探查者 隙界星吻号
function c9910670.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,25451383)
	e1:SetTarget(c9910670.thtg)
	e1:SetOperation(c9910670.thop)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9910670.limcon)
	c:RegisterEffect(e2)
end
function c9910670.thfilter(c,check1,check2)
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE) and c:IsFaceup() and check1
	local b2=c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xa952) and c:IsFaceup() and check1
	local b3=c:IsLocation(LOCATION_GRAVE) and (c:IsRace(RACE_MACHINE) or c:IsSetCard(0xa952)) and check2
	return b1 or b2 or b3
end
function c9910670.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local check1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local check2=c:IsAbleToDeck()
	if chkc then return chkc:IsControler(tp) and c9910670.thfilter(chkc,check1,check2) end
	if chk==0 then return Duel.IsExistingTarget(c9910670.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,check1,check2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c9910670.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c,check1,check2):GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	end
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	end
end
function c9910670.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if label==2 and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetCondition(c9910670.thcon2)
		e1:SetOperation(c9910670.thop2)
		tc:RegisterEffect(e1)
	end
end
function c9910670.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c9910670.thop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.Hint(HINT_CARD,0,9910670)
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c9910670.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910670.limcon(e)
	return Duel.IsExistingMatchingCard(c9910670.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
