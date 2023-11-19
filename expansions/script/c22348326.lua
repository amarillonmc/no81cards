--龙 之 魔 女  卢 尔 巴 哈
local m=22348326
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	c:EnableReviveLimit()
	--fdd
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22348326)
	e1:SetCondition(c22348326.tgcon)
	e1:SetTarget(c22348326.tgtg)
	e1:SetOperation(c22348326.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c22348326.spscon)
	e2:SetOperation(c22348326.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c22348326.spscon)
	e3:SetOperation(c22348326.spsop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e4:SetCost(c22348326.thcost)
	e4:SetTarget(c22348326.thctg)
	e4:SetOperation(c22348326.thcop)
	c:RegisterEffect(e4)
	--count
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c22348326.adjustop)
	c:RegisterEffect(e5)
	
end
function c22348326.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348326.thhfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,Duel.GetTurnCount())
	local tc=g:GetFirst()
	while tc do
	Card.ResetFlagEffect(tc,22348326)
	local ex=Effect.CreateEffect(tc)
	ex:SetType(EFFECT_TYPE_SINGLE)
	tc:RegisterFlagEffect(22348326,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348326,1))
		tc=g:GetNext()
	end
end
function c22348326.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348326.thhfilter(c,id)
	return c:IsRace(RACE_SPELLCASTER) and c:GetTurnID()==id and c:IsReason(REASON_EFFECT) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c22348326.thctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22348326.thhfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,Duel.GetTurnCount())
	if chk==0 then return g:GetCount()>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,0)
end
function c22348326.thcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22348326.thhfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,Duel.GetTurnCount())
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
function c22348326.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348326.tgfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c22348326.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	local ct=c:GetOverlayCount()
	if chk==0 then return Duel.IsExistingTarget(c22348326.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c22348326.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,ct,nil)
end
function c22348326.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while c:IsRelateToEffect(e) and tc do
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
end
function c22348326.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c22348326.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348326.spsfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function c22348326.spsop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(c22348326.spsfilter,nil,e,tp)
	local tgc=tg:GetCount()
	if tgc>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<tgc then return end
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end





