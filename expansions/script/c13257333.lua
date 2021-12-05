--超时空世界 古拉迪乌斯星
local m=13257333
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(cm.eqcost)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	]]
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,TAMA_THEME_CODE+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.eqcon1)
	e3:SetOperation(cm.eqop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_ONFIELD,0)
	e6:SetTarget(cm.imfilter)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
	elements={{"theme_effect",e2}}
	cm[c]=elements
	
end
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x351) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
	if g:GetCount()>0 then
		local tc1=g:GetFirst()
		Duel.Equip(tp,tc1,tc)
	end
end
function cm.recon(e,tp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(TAMA_THEME_CODE)
	e1:SetTargetRange(1,0)
	e1:SetValue(m)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.eqcon1)
	e2:SetOperation(cm.eqop1)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
end
function cm.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(cm.filter,nil,tp)==1
end
function cm.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g1=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
		if g1:GetCount()>0 then
			local tc1=g1:GetFirst()
			Duel.Equip(tp,tc1,tc)
		end
	end
end
function cm.imfilter(e,c)
	return c:IsSetCard(0x352) and c:GetEquipTarget()
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
