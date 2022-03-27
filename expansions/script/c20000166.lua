--概念虚械 包容
local m=20000166
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	fu_cim.Xyz_Procedure(c,12)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
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
--[[
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.r1con)
	e1:SetTarget(cm.reg1tg)
	c:RegisterEffect(e1)
	--get
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(0xff)
	e2:SetTarget(cm.tetg)
	e2:SetOperation(cm.teop)
	c:RegisterEffect(e2)
	if cm.check==nil then
		cm.check=true
		cm[0]=0
	end
--]]
	fu_cim.Hint(c,m)
end
function cm.xyzf(g)
	return g:GetSum(Card.GetRank)==12
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
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
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,nil)
	if count>0 and g:GetCount()>0 and c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=g:Select(tp,1,count,nil)
		Duel.Overlay(c,g)
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
--[[
function cm.r1con(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.reg1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	cm[0]=e:GetHandler()
	return false
end
function cm.detfilter(c)
	return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_LOST_TARGET)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return cm[0]~=0 and eg:IsExists(cm.detfilter,1,nil) end
	local xc=cm[0]
	e:SetLabelObject(xc)
Debug.Message(xc)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	--atk
	local xc=e:GetLabelObject()
Debug.Message(xc)
	if (cm.detfilter(e:GetHandler()) and eg:IsContains(e:GetHandler())) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.val3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		xc:RegisterEffect(e1)
		xc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	cm[0]=0
end
--]]