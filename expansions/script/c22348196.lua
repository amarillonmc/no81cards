--植 实 兽  潘 拿 普 鲁 斯
local m=22348196
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348196,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348196)
	e1:SetTarget(c22348196.sptg)
	e1:SetOperation(c22348196.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348196,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22348196)
	e2:SetCondition(c22348196.spcon)
	e2:SetTarget(c22348196.sptg)
	e2:SetOperation(c22348196.spop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348196,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348196.spxcon)
	e3:SetCost(c22348196.spxcost)
	e3:SetTarget(c22348196.spxtg)
	e3:SetOperation(c22348196.spxop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(1,22350205)
	e4:SetDescription(aux.Stringid(22348205,2))
	e4:SetCondition(c22348196.spxcon2)
	c:RegisterEffect(e4)
	c22348196.discard_effect=e3
	--count
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_HAND)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCondition(c22348196.checkcon)
		e4:SetOperation(c22348196.checkop)
		c:RegisterEffect(e4)
end
function c22348196.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c22348196.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22348196,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348196,5))
end
function c22348196.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:Is(LOCATION_ONFIELD))
end
function c22348196.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348196.tgfilter,1,nil)
end
function c22348196.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348196.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(22348196,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c22348196.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=ag:Filter(Card.IsRelateToEffect,nil,re)
	local g=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local gg=g:Filter(Card.IsAbleToHand,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348196,3)) then
		Duel.BreakEffect()
		Duel.SendtoHand(gg,tp,REASON_EFFECT)
	end
end
function c22348196.spxcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348196)>0
end
function c22348196.spxcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22348205)
end
function c22348196.spxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22348196.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x707)
end
function c22348196.spxtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_REMOVED)) and c22348196.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22348196.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22348196.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22348196.filter(c)
	return  c:IsRace(RACE_PLANT) and c:IsXyzSummonable(nil)
end
function c22348196.spxop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c22348196.filter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348196,4)) then
		Duel.BreakEffect()
	local tg=Duel.SelectMatchingCard(tp,c22348196.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		Duel.XyzSummon(tp,tc,nil)
	end
	end
end











