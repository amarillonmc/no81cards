--永世乐土
function c32131301.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,32131301+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32131301.actg) 
	e1:SetOperation(c32131301.acop) 
	c:RegisterEffect(e1)   
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,23131301) 
	e2:SetTarget(c32131301.sptg) 
	e2:SetOperation(c32131301.spop) 
	c:RegisterEffect(e2) 
end
c32131301.SetCard_HR_flame13=true  
function c32131301.filter(c)
	return c.SetCard_HR_flame13 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32131301.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131301.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32131301.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32131301.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c32131301.rlfil(c) 
	return c:IsReleasable() and c.SetCard_HR_flame13  
end 
function c32131301.rlgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c32131301.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)  
end 
function c32131301.spfil(c,e,tp,rg) 
	local x=0 
	local xcode=c.HR_Flame_CodeList
	local rc=rg:GetFirst() 
	while rc do 
	if xcode and rc and rc:GetCode()==xcode then   
	x=x+1   
	end 
	rc=rg:GetNext() 
	end 
	if x>0 then 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,rg,c)>0   
	else return false end 
end 
function c32131301.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c32131301.rlfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c32131301.rlgck,2,2,e,tp) end 
	local rg=g:SelectSubGroup(tp,c32131301.rlgck,false,2,2,e,tp) 
	Duel.Release(rg,REASON_COST) 
	rg:KeepAlive() 
	e:SetLabelObject(rg)
end 
function c32131301.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local rg=e:GetLabelObject() 
	local g=Duel.GetMatchingGroup(c32131301.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,rg) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 












