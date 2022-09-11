--绣球花之寻芳精
function c98876723.initial_effect(c)  
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98876723)
	e1:SetCondition(c98876723.thcon)
	e1:SetTarget(c98876723.thtg)
	e1:SetOperation(c98876723.thop)
	c:RegisterEffect(e1)  
	--xx 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(98876723,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98876723.actg)
	e1:SetOperation(c98876723.acop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_SZONE,0)
	e2:SetTarget(c98876723.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,18876723)
	e3:SetTarget(c98876723.destg)
	e3:SetOperation(c98876723.desop)
	c:RegisterEffect(e3) 
	--SpecialSummon  
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e4:SetCondition(c98876723.spcon) 
	e4:SetOperation(c98876723.spop)
	c:RegisterEffect(e4) 
end 
function c98876723.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98876723.thfilter(c)
	return c:IsCode(78610936) and c:IsAbleToHand()
end
function c98876723.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98876723.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98876723.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98876723.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end  
function c98876723.desfilter(c)
	return c:GetSequence()<5
end
function c98876723.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c98876723.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98876723.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98876723.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98876723.eftg(e,c) 
	return c:IsCode(78610936) 
end 
function c98876723.xfil(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra() and c:GetOverlayCount()>0 
end
function c98876723.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c98876723.xfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98876723.xfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c98876723.xspfil(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c98876723.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	Duel.SendtoGrave(mg,REASON_EFFECT)
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then  
		local g=mg:Filter(aux.NecroValleyFilter(c98876723.xspfil),nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and g:GetCount()>0 then 
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			if g:GetCount()>ft then 
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   g=g:Select(tp,ft,ft,nil)
			end 
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
		end
	end
end 
function c98876723.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x988)   
end  
function c98876723.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c98876723.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) 
	and Duel.GetFlagEffect(tp,98876723)==0 
end
function c98876723.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876723.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,98876723)==0 and Duel.SelectYesNo(tp,aux.Stringid(98876723,1)) then 
	Duel.Hint(HINT_CARD,0,98876723)  
	Duel.RegisterFlagEffect(tp,98876723,RESET_PHASE+PHASE_END,0,1)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 


