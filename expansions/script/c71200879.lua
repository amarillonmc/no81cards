--绝音魔兽·告死之白
function c71200879.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71200879)
	e1:SetTarget(c71200879.sptg)
	e1:SetOperation(c71200879.spop)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71200880)
	e2:SetTarget(c71200879.distg)
	e2:SetOperation(c71200879.disop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e3:SetCondition(c71200879.xdiscon) 
	e3:SetCost(c71200879.xdiscost) 
	c:RegisterEffect(e3) 
end
function c71200879.sckfil(c) 
	return c:IsFaceup() and c:IsLevelAbove(1)  
end 
function c71200879.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71200879.sckfil(chkc) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71200879.sckfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71200879.sckfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71200879.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.SelectYesNo(tp,aux.Stringid(71200879,0)) then 
				Duel.BreakEffect()  
				local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
				Duel.SynchroSummon(tp,sc,nil,nil) 
			end 
		end
	end 
end
function c71200879.xdckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x895) 
end 
function c71200879.xdiscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(c71200879.xdckfil,tp,LOCATION_MZONE,0,1,nil) 
end 
function c71200879.xdiscost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700) 
end 
function c71200879.disfil(c) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.NegateAnyFilter(c)
end 
function c71200879.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(1-tp) and c71200879.disfil(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c71200879.disfil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,c71200879.disfil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c71200879.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end 
end 



