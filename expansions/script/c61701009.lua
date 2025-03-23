--黑森林的眼珠儿鸟
function c61701009.initial_effect(c)
	--aux.AddCodeList(c,61701001)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,61701009+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c61701009.sprcon)
	e1:SetOperation(c61701009.sprop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,61701009)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c61701009.thtg)
	e2:SetOperation(c61701009.thop)
	c:RegisterEffect(e2)
end
function c61701009.ctfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701009.chkfilter(c)
	return not c:IsCode(61701009) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c61701009.sprcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c61701009.ctfilter,tp,LOCATION_MZONE,0,nil)>=Duel.GetMatchingGroupCount(c61701009.ctfilter,tp,0,LOCATION_MZONE,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c61701009.chkfilter,tp,LOCATION_HAND,0,1,nil)
end
function c61701009.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c61701009.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c61701009.thfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c61701009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61701009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c61701009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c61701009.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c61701009.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c61701009.splimit(e,c)
	return (c:IsLevelAbove(1) or not (c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK))) and c:IsLocation(LOCATION_EXTRA)
end
