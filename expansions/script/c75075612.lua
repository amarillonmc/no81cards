--梦化现实，现实化梦
function c75075612.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75075612)
	e1:SetTarget(c75075612.target)
	e1:SetOperation(c75075612.activate)
	c:RegisterEffect(e1)   
	 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075612,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75075613)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75075612.drtg)
	e2:SetOperation(c75075612.drop)
	c:RegisterEffect(e2) 
end
--
function c75075612.cfilter1(c,tp)
	return c:IsCode(75080003) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
end
function c75075612.cfilter2(c,e,tp)
	return c:IsCode(75080001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75075612.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075612.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c75075612.cfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75075612.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local gg=Duel.SelectMatchingCard(tp,c75075612.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	if gg:GetCount()>0 then
		Duel.SendtoHand(gg,nil,REASON_EFFECT)
		if Duel.ConfirmCards(gg,1-tp)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c75075612.cfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
--
function c75075612.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075612.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c75075612.spfilter(c,e,tp)
	return (c:IsSetCard(0x757) or c:IsSetCard(0x758)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c75075612.thfilter(c,e,tp)
	return (c:IsSetCard(0x757) or c:IsSetCard(0x758)) and c:IsAbleToHand()
end
function c75075612.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<1 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75075612.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		local tc=g:GetFirst()
		while tc do
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(75075612,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c75075612.thcon)
			e1:SetOperation(c75075612.thop)
			Duel.RegisterEffect(e1,tp)
			tc=g:GetNext()
		end
	end	
end
function c75075612.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75075612)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c75075612.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetLabelObject(),POS_FACEUP_ATTACK)
end