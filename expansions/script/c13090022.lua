--朝如青丝暮成雪
local m=13090022
local cm=_G["c"..m]
function c13090022.initial_effect(c)
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,13090022)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,13091022)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.prop)
	c:RegisterEffect(e4)

end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
return Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(function(c) return not c:IsSetCard(0xe08) end,tp,LOCATION_HAND,0,1,nil)
end
function cm.penfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsSetCard(0xe08)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	Duel.Destroy(c,REASON_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if op==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.splimit)
		Duel.RegisterEffect(e2,tp)
	else
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SKIP_BP)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
   end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)
end
function cm.prop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.SelectMatchingCard(tp,function(c) return not c:IsSetCard(0xe08) end,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	local tc=g:GetFirst()
	local t={}
	local ta=1
	local i=0
	while i<=0xffff do
	if tc:IsSetCard(i) then
	t[ta]=i
	ta=ta+1
	end
	i=i+1
	end
if Duel.IsExistingMatchingCard(function(c,t) return (c:IsSetCard(t[1]) or c:IsSetCard(t[2]) or c:IsSetCard(t[3])) and c:IsType(TYPE_FIELD) end,tp,LOCATION_DECK,0,1,nil,t) then
local tb=Duel.SelectMatchingCard(tp,function(c,t) return (c:IsSetCard(t[1]) or c:IsSetCard(t[2]) or c:IsSetCard(t[3])) and c:IsType(TYPE_FIELD) end,tp,LOCATION_DECK,0,1,1,nil,t):GetFirst()
	 if tb then
		local te=tb:GetActivateEffect()
		local b1=tb:IsAbleToHand()
		local b2=te:IsActivatable(tp,true,true)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tb,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tb)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tb,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tb:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tb,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if op==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.splimit)
		Duel.RegisterEffect(e2,tp)
	else
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SKIP_BP)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
end
end
end
end
end














