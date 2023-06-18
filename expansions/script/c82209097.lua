--清莲仙 艾莉佳
local m=82209097
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)  
	--tohand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.con)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end
function cm.actfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)  
	return c:IsSetCard(0xc298) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function cm.filter2(c)  
	return c:IsCode(m) and c:IsFaceup()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g) 
		if Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil)) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.sumlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e1,tp)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	Duel.RegisterEffect(e2,tp) 
end  
function cm.sumlimit(e,c)  
	return c:IsType(TYPE_EFFECT)  
end  