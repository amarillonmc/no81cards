--夏日乱斗·水着狮子王
function c9981479.initial_effect(c)
	  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981479,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9981479+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c9981479.sptg)
	e2:SetOperation(c9981479.spop)
	c:RegisterEffect(e2)
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,9981479)
	e2:SetCondition(c9981479.drcon)
	e2:SetTarget(c9981479.drtg)
	e2:SetOperation(c9981479.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981479,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,99814790)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9981479.spcon)
	e2:SetTarget(c9981479.sptg2)
	e2:SetOperation(c9981479.spop2)
	c:RegisterEffect(e2)
end
function c9981479.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9981479,0xba5,0x11,3000,2000,8,RACE_WARRIOR,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981479.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9981479,0xba5,0x11,3000,2000,8,RACE_WARRIOR,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		--redirect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981479,0))
end
function c9981479.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c9981479.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9981479.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c9981479.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9981479.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9981479.cfilter2(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c9981479.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(c9981479.cfilter2,1,nil,tp)
end
function c9981479.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981479.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9981479.spfilter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9981479.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9981479.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9981479.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
