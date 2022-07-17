--狂热精武门！
local m=33711901
local cm=_G["c"..m]
function cm.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.check(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.check,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.check,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.check(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.check2(c)
	return not c:IsForbidden() and c:IsType(TYPE_EQUIP)
end
function cm.filter2(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_EQUIP)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.GetFirstTarget()
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if not dc:IsRelateToEffect(e) or not dc:IsFaceup() then return end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.check2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ct,nil)
		for tc in aux.Next(g) do
			if not Duel.Equip(tp,tc,dc) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,dc)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,99,nil)
		if g:GetCount()>0 then
			local num=Duel.SendtoGrave(g,REASON_EFFECT)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(num*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			dc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(m,3))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			e3:SetTarget(cm.sumlimit)
			Duel.RegisterEffect(e3,tp)
		end 
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return true
end