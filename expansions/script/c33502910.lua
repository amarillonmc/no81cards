--银河之歌
local m=33502910
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33502900)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp,mc)
	if Duel.GetLocationCountFromEx(tp,tp,mc,c)<1 then return false end
	if c:IsCode(33502900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		return true 
	elseif c:IsCode(33502908) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return true
	else
		return false
	end
end
function cm.thfilter(c,e,tp)
	return aux.IsCodeListed(c,33502900) and c:IsAbleToGrave() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp)
	if g2:GetCount()>0 then
		if Duel.SendtoGrave(g2,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,g2)
			if g1:GetCount()>0 then
				local tc=g1:GetFirst()
				local stp=0
				if tc:IsCode(33502908) then
					stp=SUMMON_TYPE_RITUAL
				end
				if  Duel.SpecialSummonStep(tc,stp,tp,tp,false,true,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCode(EVENT_CHAINING)
					e1:SetCondition(cm.con)
					e1:SetOperation(cm.op)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and re:GetHandler():IsLocation(LOCATION_ONFIELD) and aux.IsCodeListed(re:GetHandler(),33502900)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end