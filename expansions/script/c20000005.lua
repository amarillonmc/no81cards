--殉道者的契约
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000002") end) then require("script/c20000002") end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(fu_kurusu.A_con1)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e2
function cm.cosf1(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cosf1,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cosf1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tgf1(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end