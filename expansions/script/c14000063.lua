--嵌合魔术-爆裂
local m=14000063
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,14000055,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),1,true,false)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(14000055)
	c:RegisterEffect(e1)
	--Gandora-X
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.extg)
	e2:SetOperation(cm.exop)
	c:RegisterEffect(e2)
end
function cm.ORI(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Origic
end
function cm.tdfilter(c)
	return cm.ORI(c) and c:IsAbleToDeck()
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,nil,LOCATION_ONFIELD)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local boo1,atk1=0,0
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		boo1=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	local tc=g:GetFirst()
	if tc then
		local batk=tc:GetBaseAttack()
		local batt=tc:GetOriginalAttribute()
		if batk~=0 then
			atk1=batk
		end
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) and tc:IsFaceup() and boo1==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(batt)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(batk)
			c:RegisterEffect(e2)
		end
	end
	local oc=Duel.GetOperatedGroup():GetFirst()
	if Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and oc and oc:IsLocation(LOCATION_REMOVED) and atk1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,atk1,REASON_EFFECT)
			end
		end
	end
end