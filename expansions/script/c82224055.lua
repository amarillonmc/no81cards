local m=82224055
local cm=_G["c"..m]
cm.name="尸狼王"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),aux.NonTuner(Card.IsRace,RACE_BEAST),1)  
	c:EnableReviveLimit()
	--summon success  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetOperation(cm.sumsuc)  
	c:RegisterEffect(e1)  
	--to hand
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e3:SetCountLimit(1,m)
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetCondition(cm.thcon)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)   
	e1:SetTargetRange(0xff, 0xff)  
	e1:SetValue(LOCATION_REMOVED)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)  
end  
function cm.filter(c)  
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_BEAST) and c:IsType(TYPE_TUNER)
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()  
		if tc:IsLocation(LOCATION_HAND) then  
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_FIELD)  
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
			e1:SetTargetRange(1,0)  
			e1:SetValue(cm.aclimit)  
			e1:SetLabel(tc:GetCode())  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e1,tp)  
		end	
	end  
end  
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsCode(e:GetLabel())  
end 