local m=90700020
local cm=_G["c"..m]
cm.name="钟楼使徒 海斗"
function cm.initial_effect(c)
	aux.AddCodeList(c,90700019)
	aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetValue(5)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	e3:SetValue(7)
	c:RegisterEffect(e3)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local con2=e:GetHandler():IsForbidden()
	local con3=Duel.GetTurnPlayer()==tp
	local con4=Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
	local con5=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsPublic,nil):FilterCount(aux.IsCodeListed,nil,90700019)>0
	return con1 and not con2 and con3 and con4 and con5
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end