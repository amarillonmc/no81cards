--方舟骑士-末药
c115029.named_with_Arknight=1
function c115029.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(115029,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,115029)
	e1:SetTarget(c115029.thtg)
	e1:SetOperation(c115029.thop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,115030)
	e2:SetCondition(c115029.spcon)
	e2:SetTarget(c115029.sptg)
	e2:SetOperation(c115029.spop)
	c:RegisterEffect(e2)
end
function c115029.thfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsFaceup() and not c:IsCode(115029)  
end 
function c115029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115029.thfil,tp,LOCATION_EXTRA,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end 
function c115029.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c115029.thfil,tp,LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end 
end 
function c115029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c115029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115029.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c115029.srcon)
	e1:SetOperation(c115029.srop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
	end 
	end
end
function c115029.srfil(c,e,tp) 
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) 
end
function c115029.srcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c115029.srfil,tp,LOCATION_DECK,0,1,nil,e,tp) 
end
function c115029.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,115029)
	local tc=Duel.SelectMatchingCard(tp,c115029.srfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end 


