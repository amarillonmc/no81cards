--
--Script by Real_Scl
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=40008677
local cm=_G["c"..m]
if not rsv.InfernalKnight then
	rsv.InfernalKnight={}
	rsik=rsv.InfernalKnight
function rsik.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return Duel.IsPlayerAffectedByEffect(tp,m) and c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x10c5) and c:IsAbleToGraveAsCost()
end
function rsik.cost(extrafun)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(rsik.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
		local g=Duel.GetMatchingGroup(rsik.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local reason= tc:IsLocation(LOCATION_DECK) and REASON_COST or REASON_COST+REASON_DISCARD 
		Duel.SendtoGrave(tc,reason)
		if extrafun then
			extrafun(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
------------------------
end
------------------------
if cm then
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th,tg",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.activate)
	--splimit
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e1:SetRange(LOCATION_FZONE)
	--e1:SetTargetRange(1,0)
	--e1:SetCondition(cm.atkcon)
	--e1:SetTarget(cm.splimit)
	--c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10c5))
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(m)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.costtg)
	e4:SetOperation(cm.costop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--change discard cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(m)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
function cm.thfilter(c)
	return c:IsSetCard(0x10c5) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.activate(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	end
end
function cm.actcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() 
end
function cm.costtg(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and tc==e:GetHandler() and tc:GetEffectCount(m)>0
		and tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(m)
end
function cm.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function cm.costchk(e,te,tp)
	local tc=te:GetHandler()
	return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tc:GetCode())
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	rsof.SelectHint(tp,"rm")
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.eftg(e,c)
	return c:IsSetCard(0x10c5) and c:IsType(TYPE_QUICKPLAY)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10c5) and c:IsType(TYPE_MONSTER)
end
function cm.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_DRAGON)
end
------------------------
end