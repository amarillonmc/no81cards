--概念虚械 包容
local m=20000166
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.xyzf,nil,3,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(fu_cim.Remove_Material_condition)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	fu_cim.Hint(c,m)
end
function cm.xyzf(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(11)
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(fu_cim.Remove_Material_cost_filter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000162,2))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local max=tc:GetOverlayCount()
	local count=tc:RemoveOverlayCard(tp,1,max,REASON_COST)
	e:SetLabel(count)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 or count==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g=g:Select(tp,1,count,nil)
	count=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if count>0 then
		g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			g=g:Select(tp,1,count,nil)
			Duel.BreakEffect()
			Duel.Overlay(c,g)
		end
	end
end
--e2
function cm.tgf2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcfd1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgf2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tgf2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
--e3
function cm.val3(e,re,rp)
	if e:GetHandlerPlayer()==re:GetHandlerPlayer() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end