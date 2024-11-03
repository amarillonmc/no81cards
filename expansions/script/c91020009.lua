--真神 神官塞特
local m=91020009
local cm=c91020009
function c91020009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x9d1),2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,POS_FACEUP,REASON_COST,cm.op1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end
function cm.ft(c)
return c:IsFaceup() and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
local g=Duel.GetMatchingGroup(cm.ft,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ft,tp,LOCATION_ONFIELD,0,2,e:GetHandler()) end
	local rg=g:Select(tp,2,2,e:GetHandler())
	Duel.Release(rg,REASON_COST)
end
function cm.filter0(c)
return c:IsFaceup()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DIVINE),1,nil) and g:GetCount()>1 
end
function cm.fselect(g)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DIVINE)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
		local d=Duel.GetAttackTarget()
		if d:IsRelateToBattle()  then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	local g2=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	Duel.Release(g2,REASON_COST)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(2)
	c:RegisterEffect(e3)
		 local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetTargetRange(0,1)
	e6:SetValue(1)
	e6:SetCondition(cm.actcon)
	c:RegisterEffect(e6) 
	 local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
