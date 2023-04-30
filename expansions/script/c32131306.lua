--逐火十三英桀 帕朵菲莉丝
function c32131306.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,32131306) 
	e1:SetCost(c32131306.hspcost) 
	e1:SetTarget(c32131306.hsptg) 
	e1:SetOperation(c32131306.hspop) 
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23131306)
	e2:SetTarget(c32131306.thtg)
	e2:SetOperation(c32131306.thop)
	c:RegisterEffect(e2)
	c32131306.sp_effect=e2 
end
c32131306.SetCard_HR_flame13=true 
function c32131306.hspcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
end 
function c32131306.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end  
end
function c32131306.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	Duel.ConfirmDecktop(tp,1)  
	if tc.SetCard_HR_flame13 then
		if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end  
	else 
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT) 
	end 
end 
function c32131306.thfilter(c)
	return c.SetCard_HR_flame13 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c32131306.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131306.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32131306.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32131306.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c32131306.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c32131306.splimit(e,c)
	if c:IsType(TYPE_TOKEN) then 
	return c:GetCode()<32131200 or c:GetCode()>32131400  
	else
	return not c.SetCard_HR_flame13 
	end 
end 



