--[[
败亡仍胜
Disarray
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[If you have taken 3000 or more damage this turn, and control no other cards: Shuffle all cards in your hand, Deck and GY into your opponent's Deck, and if you do,
	during the next Xth End Phase after this card resolves, your opponent's LP becomes 0.
	(X is 10 minus the number of cards your opponent controls and in their hand when this card resolves. If X is lower than 0, apply the effect immediately.)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings(TIMING_BATTLE_STEP_END)
	e1:SetFunctions(s.condition,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(ep,id) then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE|PHASE_END,0,1,0)
	end
	Duel.UpdateFlagEffectLabel(ep,id,ev)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.PlayerHasFlagEffect(tp,id) and Duel.GetFlagEffectLabel(tp,id)>=3000 and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(Card.IsAbleToDeck,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsAbleToDeck,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,aux.ExceptThis(e))
	if #g>0 and Duel.ShuffleIntoDeck(g,1-tp)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local X=10-Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD|LOCATION_HAND)
		if X>0 then
			local rct=X+Duel.GetNextPhaseCount(PHASE_END)-1
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:Desc(1,id)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:OPT()
			e1:SetLabel(X,rct-X,0)
			e1:SetCondition(s.wincon)
			e1:SetOperation(s.winop)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,rct)
			Duel.RegisterEffect(e1,tp)
		else
			Duel.SetLP(1-tp,0)
		end
	end
end
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	local X,diff=e:GetLabel()
	if diff~=0 then
		e:SetLabel(X,0,0)
		return false
	end
	return true
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local X,diff,ct=e:GetLabel()
	local c=e:GetOwner()
	ct=ct+1
	e:SetLabel(X,diff,ct)
	c:SetTurnCounter(ct)
	if ct==X then
		Duel.SetLP(1-tp,0)
		e:Reset()
	end
end