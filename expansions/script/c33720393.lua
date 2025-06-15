--[[
已为幸福战
Fought For Happiness
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[At the start of your next Battle Phase after this card was activated, or after this Set card was destroyed by your opponent: Your opponent gains LP equal to your current LP, and if they do, at the end of that Battle Phase, they must choose 1 of the following effects for you to apply.
	● They take damage equal to the LP gained this way.
	● You draw 1 card for each 1000 LP they gained this way.
	If this effect was activated because this Set card was destroyed by your opponent, you choose which effect to apply instead.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_RECOVER|CATEGORY_DAMAGE|CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_RECOVER|CATEGORY_DAMAGE|CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetFunctions(
		s.condition,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e2)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_DECK) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and rp==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:Desc(1,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	e1:OPT()
	e1:SetLabel(e:GetCode()==EVENT_DESTROYED and 1 or 0)
	e1:SetCondition(aux.TurnPlayerCond(0))
	e1:SetOperation(s.applyop)
	e1:SetReset(RESET_PHASE|PHASE_BATTLE_START,Duel.GetNextBattlePhaseCount(tp))
	Duel.RegisterEffect(e1,tp)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.Recover(1-tp,math.max(Duel.GetLP(tp),0),REASON_EFFECT)
	if lp>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:Desc(2,id)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_BATTLE)
		e1:OPT()
		e1:SetLabel(lp,e:GetLabel())
		e1:SetOperation(s.applyop2)
		e1:SetReset(RESET_PHASE|PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.applyop2(e,tp,eg,ep,ev,re,r,rp)
	local lp,chk=e:GetLabel()
	local op=chk and tp or 1-tp
	local desc=chk and 5 or 3
	local b2=lp>=1000 and Duel.IsPlayerCanDraw(tp,math.floor(lp/1000))
	local opt=aux.Option(op,id,desc,true,b2)
	if opt==0 then
		Duel.Damage(1-tp,lp,REASON_EFFECT)
	elseif opt==1 then
		Duel.Draw(tp,math.floor(lp/1000),REASON_EFFECT)
	end
end