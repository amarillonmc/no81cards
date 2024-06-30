--[[
晦空士 ～闪回的黑流～
Sepialife - Back On Black
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[During your opponent's Standby Phase, if you control no face-up cards: You can send this card from your hand to the GY; for the rest of this turn,
	each time your opponent activates a card or effect, take 1 "Sepialife" monster from your Deck immediately after it resolves, and shuffle it into their Deck.
	If a card(s) would be shuffled to their Deck by this effect, your opponent can take 800 damage for each, instead.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:OPT()
	e1:SetFunctions(s.condition,aux.ToGraveSelfCost,aux.DummyCost,s.operation)
	c:RegisterEffect(e1)
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and not Duel.IsExists(false,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterHint(1-tp,id+100,PHASE_END,1,id,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(s.regop)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(s.damcon)
	e3:SetOperation(s.damop)
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:Desc(2,id)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetLabelObject(e3)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.PlayerHasFlagEffect(tp,id)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.Select(HINTMSG_TODECK,false,tp,s.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.repfilter(c,e)
	return c:GetDestination()==LOCATION_DECK and c:GetReasonEffect()==e
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eff=e:GetLabelObject()
	if chk==0 then return (r&REASON_EFFECT)~=0 and re and eg:IsExists(s.repfilter,1,nil,eff) end
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
		local c=e:GetHandler()
		local g=eg:Filter(s.repfilter,nil,eff)
		local ct=#g
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
		return true
	else
		return false
	end
end
function s.repval(e,c)
	return true
end