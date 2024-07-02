--蒸汽淑女 伊什比埃
function c40011463.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xaf1a),1)
	c:EnableReviveLimit()
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,40011463)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end) 
	e1:SetCost(c40011463.xxcost) 
	e1:SetOperation(c40011463.xxop) 
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40011463+1)
	e2:SetCost(c40011463.spcost)
	e2:SetTarget(c40011463.sptg)
	e2:SetOperation(c40011463.spop)
	c:RegisterEffect(e2) 
end
function c40011463.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xaf1a) end,tp,LOCATION_DECK,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xaf1a) end,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c40011463.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(40011457)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0) 
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c40011463.rmfil(c) 
	return c:IsSetCard(0xaf1a) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end 
function c40011463.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c40011463.rmfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local rg=Duel.SelectMatchingCard(tp,c40011463.rmfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	rg:AddCard(e:GetHandler()) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST) 
end
function c40011463.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(6) and c:IsSetCard(0xaf1a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c40011463.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011463.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40011463.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c40011463.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure()
	end
end




