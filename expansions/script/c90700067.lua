local m=90700067
local cm=_G["c"..m]
cm.name="忆晶所选中者-露比"
function cm.initial_effect(c)
	aux.AddCodeList(c,90700070)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.topcon)
	e1:SetOperation(cm.topop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.bancon)
	e2:SetOperation(cm.banop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.enable)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end
function cm.topcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function cm.topop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,e:GetHandler())==0
end
function cm.banop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
cm.selg=Group.CreateGroup()
function cm.enable(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	Duel.RegisterEffect(e1,e:GetHandlerPlayer())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	local sel=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):RandomSelect(tp,1)
	local tc=sel:GetFirst()
	Duel.HintSelection(sel)
	if aux.IsCodeListed(tc,90700070) then
		cm.selg:Clear()
		cm.selg:AddCard(tc)
		Duel.ChangeChainOperation(ev,cm.changedop)
	end
end
function cm.changedop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	g:AddCard(e:GetHandler())
	g:AddCard(cm.selg:GetFirst())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end