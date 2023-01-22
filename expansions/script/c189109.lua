--灰烬机兵-哈迪鲁特
function c189109.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCountLimit(1,189109) 
	e1:SetCost(c189109.spcost) 
	e1:SetTarget(c189109.sptg) 
	e1:SetOperation(c189109.spop) 
	c:RegisterEffect(e1) 
	--sort 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,289109)  
	e2:SetCondition(c189109.stcon)
	e2:SetTarget(c189109.sttg) 
	e2:SetOperation(c189109.stop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
function c189109.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,3,nil,POS_FACEDOWN) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,3,3,nil,POS_FACEDOWN) 
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end 
function c189109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c189109.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end   
end 
function c189109.sckfil(c,tp) 
	return c:IsRace(RACE_MACHINE) and c:IsControler(tp) 
end 
function c189109.stcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c189109.sckfil,1,e:GetHandler(),tp) 
end 
function c189109.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,5,nil) end 
end 
function c189109.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xca6)  
end 
function c189109.tgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0xca6)  
end 
function c189109.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c189109.spfil,nil,e,tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(189109,2)) then
		Duel.DisableShuffleCheck() 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c189109.spfil,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		ct=ct-sg:GetCount() 
		g:Sub(sg) 
	end 
	if g:IsExists(c189109.tgfil,1,nil) then 
		Duel.DisableShuffleCheck() 
		local dg=g:Filter(c189109.tgfil,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT) 
		ct=ct-dg:GetCount() 
	end 
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end 









