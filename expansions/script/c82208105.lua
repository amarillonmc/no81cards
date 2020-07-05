local m=82208105
local cm=_G["c"..m]
cm.name="星遗物的圣选士"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--extra summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)  
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)  
	e2:SetTarget(aux.TargetBoolFunction(cm.filter3))  
	c:RegisterEffect(e2)  
end
function cm.filter1(c)  
	return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() 
end  
function cm.filter2(c,tp)  
	return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,c)
end  
function cm.filter3(c)  
	return c:IsSetCard(0x10c) and c:IsLevel(4) 
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))  
	local tc=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,tc)  
	if tc and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)==true then   
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetCode(EFFECT_CHANGE_TYPE)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)  
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)  
			tc:RegisterEffect(e1) 
			local e2=Effect.CreateEffect(c)  
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetCategory(CATEGORY_TOHAND)  
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCondition(cm.thcon)  
			e2:SetOperation(cm.thop) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
			tc:RegisterEffect(e3)
			if g:GetCount()<=0 then return end
			Duel.SendtoHand(g,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.thfilter(c,e)  
	return aux.GetColumn(c)==aux.GetColumn(e:GetHandler())
end 
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.thfilter,1,nil,e)
end   
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SendtoHand(c,nil,REASON_EFFECT)  
end  