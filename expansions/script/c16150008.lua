--王命的集结
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150008,"OUMEI")
function cm.initial_effect(c,flag)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.con1)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(cm.con2)
	c:RegisterEffect(e5)
	if flag and flag==true then
		return e1,e2,e3,e4,e5
	end
end
function cm.afilter(c)
	return rk.check(c,"DAIOU") and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	sg:KeepAlive()
	e:SetLabelObject(sg)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tc=e:GetLabelObject():GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
			--serch
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(m,5)
			e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e2:SetTarget(cm.thtg2)
			e2:SetOperation(cm.thop2)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.thfilter(c)
	return rk.check(c,"DAIOU") and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgfilter(c)
	return rk.check(c,"OUMEI") and c:IsAbleToGrave()
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
			if not Duel.Equip(tp,tc,c) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			if tc:GetOriginalType()&TYPE_EQUIP~=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.con1(e,tp)
	local c=e:GetHandler()
	return not Duel.IsPlayerAffectedByEffect(tp,16150008) and c:GetEquipTarget()~=nil
end
function cm.con2(e,tp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,16150008) and c:GetEquipTarget()~=nil and not c:IsStatus(STATUS_CHAINING)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsLocation(LOCATION_FZONE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thfilter2(c)
	return (rk.check(c,"DAIOU") or rk.check(c,"OUMEI") or c:IsSetCard(0xccd)) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end 
		Duel.MoveSequence(c,5)
		local e1,e2,e3,e4,e5=cm.initial_effect(c,true)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
