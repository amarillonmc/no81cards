--言叶无限欺 感伤
local m=33403524
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	 XY.magane(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
function cm.costfilter1(c)
	return  c:IsSetCard(0x6349) or c:IsCode(33403520) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.filter(c,tp)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520) or c:GetOwner()==1-tp) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	local tc=g:GetFirst()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
	Duel.Draw(tp,2,REASON_EFFECT)   
end

