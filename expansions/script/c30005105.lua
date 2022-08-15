--深红的索引
local m=30005105
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetTurnCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop1)
	e1:SetLabel(ph)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop2)
	e2:SetLabel(ph)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.effcon)
	e3:SetOperation(cm.effop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and re:IsActiveType(TYPE_TRAP)
		and Duel.GetTurnCount()==e:GetLabel()
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1,pt)
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local ct=e:GetLabelObject():GetLabel()
	if ct==0 then ct=1 end
	e:GetLabelObject():SetLabel(ct-1,pt)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	local ct,pt=e:GetLabel()
	return e:GetLabel()>0 and Duel.GetTurnCount()~=pt
end
function cm.sfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local ct,pt=e:GetLabel()
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
