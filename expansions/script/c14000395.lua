--终将荒神为碑
local m=14000395
local cm=_G["c"..m]
--cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsCode(14000380) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_GRAVE,0,nil)
		if ct<=2 or not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			while ct>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
				sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))+1
				if sel==1 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCondition(cm.defcon)
					e1:SetTarget(cm.splimit)
					e1:SetTargetRange(1,1)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1,true)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				elseif sel==2 then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_CANNOT_SUMMON)
					e2:SetRange(LOCATION_MZONE)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,1)
					e2:SetCondition(cm.defcon)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
				elseif sel==3 then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_FIELD)
					e3:SetCode(EFFECT_CANNOT_TO_HAND)
					e3:SetRange(LOCATION_MZONE)
					e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e3:SetTargetRange(1,1)
					e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
					e3:SetCondition(cm.defcon)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e3)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
				end
				ct=ct-1
				if ct>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,5)) then ct=0 end
			end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCondition(cm.defcon)
			e1:SetTarget(cm.splimit)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCondition(cm.defcon)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_TO_HAND)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(1,1)
			e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
			e3:SetCondition(cm.defcon)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		end
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function cm.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCode(14000380)
end