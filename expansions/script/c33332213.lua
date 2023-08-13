--塑梦之授秽者
function c33332213.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,c33332213.mfilter,0,99)   
	--code
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(33332213,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)   
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,33332213) 
	e1:SetCost(c33332213.cdcost)
	e1:SetTarget(c33332213.cdtg) 
	e1:SetOperation(c33332213.cdop) 
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33332213,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)   
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,13332213) 
	e2:SetCost(c33332213.spcost)
	e2:SetTarget(c33332213.sptg)
	e2:SetOperation(c33332213.spop)
	c:RegisterEffect(e2) 
	--immuse 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_IMMUNE_EFFECT) 
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) end) 
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(33332200) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end)
	c:RegisterEffect(e3)
end
function c33332213.mfilter(c,syncard)
	return true 
end
function c33332213.cdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c33332213.cdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return re and re:IsActiveType(TYPE_MONSTER) end  
end 
function c33332213.cdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local rc=re:GetHandler()
	if rc and rc:IsRelateToEffect(re) then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(33332200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		rc:RegisterEffect(e1)   
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(3)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		rc:RegisterEffect(e1)   
		if Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(33332213,0)) then 
			Duel.BreakEffect()
			Duel.NegateEffect(ev) 
			Duel.Recover(1-tp,500,REASON_EFFECT)
		end 
	end 
end 
function c33332213.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(33332200) and c:IsReleasable() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCode(33332200) and c:IsReleasable() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
	Duel.Release(g,REASON_COST) 
end 
function c33332213.spfil(c,e,tp)
	return c:IsSetCard(0x3568) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33332213.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33332213.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33332213.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33332213.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end







