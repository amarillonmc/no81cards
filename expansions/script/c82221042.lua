function c82221042.initial_effect(c)  
	--spsummon  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82221042,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)   
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,82221042)  
	e1:SetCost(c82221042.spcost)  
	e1:SetTarget(c82221042.sptg)  
	e1:SetOperation(c82221042.spop)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indes  
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(82221042,1)) 
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_HAND)  
	e3:SetCountLimit(1,82221042)  
	e3:SetCost(c82221042.indcost)  
	e3:SetTarget(c82221042.indtg)  
	e3:SetOperation(c82221042.indop)  
	c:RegisterEffect(e3)  
end
function c82221042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  
function c82221042.spfilter(c,e,tp)  
	return c:IsSetCard(0x9f) and c:IsLevelAbove(5) and not c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82221042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingMatchingCard(c82221042.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)  
end  
function c82221042.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local tc=Duel.SelectMatchingCard(tp,c82221042.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()  
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1,true) 
		Duel.SpecialSummonComplete()
	end  
end  
function c82221042.indcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function c82221042.filter(c)  
	return c:IsFaceup() and (c:IsSetCard(0x9f) or c:IsSetCard(0x99)) 
end  
function c82221042.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82221042.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82221042.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82221042.filter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82221042.indop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e1:SetValue(1)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()  
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
		tc:RegisterEffect(e2)  
	end  
end  