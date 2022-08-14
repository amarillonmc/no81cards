--天基兵器过载
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2 = Rule_SpaceWeapon.spell_grave(c)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,n,nil)
	if n>0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if #g<=0 then return end
	local b=false
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	if n>1 then b=Duel.SelectYesNo(tp,aux.Stringid(m,0)) end
	for tc in aux.Next(g) do
		if b then Duel.NegateRelatedChain(tc,RESET_TURN_SET) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		if b then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end