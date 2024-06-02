--[[
更新之炎
Flame of Refreshment
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_LORE,0xff)
	--Activate only if you have 4 or more cards in your hand. Discard your entire hand, and if you do, place a number of Lore Counters on this card equal to the number of discarded cards.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_HANDES|CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.ctcon)
	e1:SetCost(s.ctcost)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--During your End Phase, if you have not Normal Summoned this turn, place 1 Lore Counter on this card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:OPT()
	e2:SetCondition(s.epcon)
	e2:SetTarget(aux.RelationTarget)
	e2:SetOperation(s.epop)
	c:RegisterEffect(e2)
	--During your 2nd Standby Phase after this card's activation, draw cards equal to the number of Lore Counters on this card, then send this card to the GY.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:OPT()
	e3:SetCondition(s.proccon)
	e3:SetTarget(aux.RelationTarget)
	e3:SetOperation(s.procop)
	c:RegisterEffect(e3)
	--[[If there are 6 or more cards with different names in your hand, and there are no cards with the same name among them: You can reveal your entire hand, and banish this card from your GY; draw 2 cards.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(1,id)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.condition)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
--E1
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetHandCount(tp)>=4
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START|PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(s.regop)
	Duel.RegisterEffect(e1,tp)
	c:CreateEffectRelation(e1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if not c:IsRelateToEffect(e) or ct>=2 then
		c:SetTurnCounter(0)
		e:Reset()
		return
	end
	if Duel.GetTurnPlayer()~=tp then return end
	ct=ct+1
	c:SetTurnCounter(ct)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local exc = (c:IsLocation(LOCATION_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE)) and c or nil
	local g=Duel.Group(Card.IsDiscardable,tp,LOCATION_HAND,0,exc,REASON_EFFECT)
	local ct=#g
	if chk==0 then return ct>0 and c:IsCanAddCounter(COUNTER_LORE,ct,false,LOCATION_SZONE) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,ct)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT)
	if #g==0 then return end
	local ct=Duel.SendtoGrave(g,REASON_EFFECT|REASON_DISCARD)
	if ct>0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() and c:IsCanAddCounter(COUNTER_LORE,ct) then
			c:AddCounter(COUNTER_LORE,ct)
		end
	end
end

--E2
function s.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function s.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanAddCounter(COUNTER_LORE,1) then
		Duel.Hint(HINT_CARD,tp,id)
		c:AddCounter(COUNTER_LORE,1)
	end
end

--E3
function s.proccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetTurnCounter()==2
end
function s.procop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(COUNTER_LORE)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Hint(HINT_CARD,tp,id)
		if Duel.Draw(tp,ct,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end

--E4
function s.gcheck(g)
	local c1,c2=g:GetFirst(),g:GetNext()
	return c1:IsCode(c2:GetCode())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetHand(tp)
	return g:GetClassCount(Card.GetCode)>=6 and not g:CheckSubGroup(s.gcheck,2,2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetHand(tp)
	if chk==0 then return #g>0 and not g:IsExists(Card.IsPublic,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end