--言叶无限欺 永远的诈欺师
local m=33403530
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	 XY.magane(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.costfilter1(c)
	return  c:IsSetCard(0x6349) or c:IsCode(33403520) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) and  Duel.GetFlagEffect(tp,m)==0 and Duel.GetFlagEffect(tp,m+30000)==0 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

