function c82228012.initial_effect(c)   
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,82228012)  
	e1:SetCondition(c82228012.spcon)  
	e1:SetTarget(c82228012.sptg)  
	e1:SetOperation(c82228012.spop)  
	c:RegisterEffect(e1) 
	--spsummon2  
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(0,TIMING_END_PHASE) 
	e2:SetCost(c82228012.sp2cost)  
	e2:SetTarget(c82228012.sp2tg)  
	e2:SetOperation(c82228012.sp2op)  
	c:RegisterEffect(e2) 
end  

function c82228012.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetCustomActivityCount(82228012,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(c82228012.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  

function c82228012.spfilter(c)  
	return c:IsSetCard(0x290)
end

function c82228012.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c82228012.spfilter,tp,LOCATION_GRAVE,0,1,nil)  
end  

function c82228012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  

function c82228012.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end  

function c82228012.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  

function c82228012.sp2filter(c,e,tp)  
	return c:IsCode(82228014) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  

function c82228012.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingMatchingCard(c82228012.sp2filter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  

function c82228012.sp2op(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228012.sp2filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  