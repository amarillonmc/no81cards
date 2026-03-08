--被遗忘的研究者 煌星忍
function c43480085.initial_effect(c)
	--to ex 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_EQUIP) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,43480085) 
	e1:SetCost(c43480085.tecost)
	e1:SetTarget(c43480085.tetg) 
	e1:SetOperation(c43480085.teop) 
	c:RegisterEffect(e1) 
	--gsp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,43480086)  
	e2:SetTarget(c43480085.gsptg) 
	e2:SetOperation(c43480085.gspop) 
	c:RegisterEffect(e2) 
end
function c43480085.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c43480085.tefil(c) 
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) and c:IsAbleToExtra()   
end 
function c43480085.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480085.tefil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end 
function c43480085.eqfil(c) 
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) 
end 
function c43480085.teop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c43480085.tefil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c43480085.eqfil,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43480085,0)) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local ec=Duel.SelectMatchingCard(tp,c43480085.eqfil,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_HAND,0,1,1,nil):GetFirst() 
		if tc and ec then
			Duel.Equip(tp,ec,tc) 
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1) 
		end
	end 
end 
function c43480085.tgfil(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGrave() 
end 
function c43480085.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480085.tgfil,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c43480085.rtfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsAbleToHand()  
end 
function c43480085.gspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local sg=Duel.SelectMatchingCard(tp,c43480085.tgfil,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil) 
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c43480085.rtfil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43480085,1)) then 
		Duel.BreakEffect() 
		local rg=Duel.SelectMatchingCard(tp,c43480085.rtfil,tp,LOCATION_ONFIELD,0,1,1,nil) 
		Duel.SendtoHand(rg,nil,REASON_EFFECT) 
	end  
end 










