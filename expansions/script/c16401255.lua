--迦勒底的圣骑士-玛修·基列莱特
local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.XyzFilter,nil,5,5)
	c:EnableReviveLimit()
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
function s.XyzFilter(c)
	return c:IsSetCard(0x5ce1) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PSYCHO)
end
function s.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function s.ovfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x5ce1) and c:IsCanOverlay()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.ovfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.HintSelection(sg)
	if #sg>0 then
		Duel.Overlay(c,sg)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,4,REASON_COST) end
	c:RemoveOverlayCard(tp,4,4,REASON_COST)
end
function s.eefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ce1)
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsLevelAbove(1) and c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(s.eefilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) end,tp,0,LOCATION_MZONE,1,nil) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.eefilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_MZONE,1,nil)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,1125},{b2,1104})
	if op==1 then
		Duel.Hint(24,0,aux.Stringid(id,0))
		local g1=Duel.GetMatchingGroup(s.eefilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g1) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(s.efilter)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		end
	elseif op==2 then
		Duel.Hint(24,0,aux.Stringid(id,1))
		local g2=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil)
		Duel.HintSelection(g2)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end