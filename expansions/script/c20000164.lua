--虚构素体 C001
local m=20000164
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	local e1,e2=fu_cim.Hint(c,m,cm.con1,1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(fu_cim.Remove_Material_condition)
	e3:SetCost(fu_cim.Remove_Material_cost)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
--e1
function cm.conf1(c)
	return c:IsSetCard(0xafd1) and c:IsFaceup()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.conf1,1,nil)
end
--e2
function cm.tgf2(c)
	return c:IsSetCard(0xafd1) and c:IsAbleToGrave()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_DISCARD_DECK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		c:RegisterEffect(e1)
	end
end