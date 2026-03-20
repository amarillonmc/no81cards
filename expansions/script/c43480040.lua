--被遗忘的研究 夏露德尔塔II形解放
function c43480040.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c43480040.lcheck)
	c:EnableReviveLimit() 
	--to hand
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,43480040) 
	e1:SetCost(c43480040.setcost)
	e1:SetTarget(c43480040.settg)
	e1:SetOperation(c43480040.setop)
	c:RegisterEffect(e1)   
	--te 
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_TOEXTRA) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43480041) 
	e2:SetCost(c43480040.tecost)
	e2:SetTarget(c43480040.tetg)
	e2:SetOperation(c43480040.teop)
	c:RegisterEffect(e2) 
	--Special Summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,43480042)
	e2:SetCondition(c43480040.spcon)
	e2:SetTarget(c43480040.sptg)
	e2:SetOperation(c43480040.spop) 
	c:RegisterEffect(e2)
end
function c43480040.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3f13)
end
function c43480040.pbfil(c) 
	return not c:IsPublic() and c:IsSetCard(0x3f13)  
end 
function c43480040.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.IsPlayerAffectedByEffect(tp,43480080) then 
		return true 
		else return Duel.IsExistingMatchingCard(c43480040.pbfil,tp,LOCATION_HAND,0,1,nil)
		end
	end
	if not Duel.IsPlayerAffectedByEffect(tp,43480080) then
		local pg=Duel.SelectMatchingCard(tp,c43480040.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
		Duel.ConfirmCards(1-tp,pg) 
	end
end
function c43480040.setfilter(c)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c43480040.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480040.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
end
function c43480040.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c43480040.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc) 
	end
end
function c43480040.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,POS_FACEDOWN) end
	local pg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,POS_FACEDOWN) 
	Duel.Remove(pg,POS_FACEDOWN,REASON_COST)  
end
function c43480040.tefil(c)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c43480040.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480040.tefil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c43480040.teop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c43480040.tefil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT) 
	end 
end 
function c43480040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c43480040.spfilter(c,e,tp)
	return c:IsCode(43480035) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43480040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43480040.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c43480040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c43480040.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true) 
		Duel.SpecialSummonComplete() 
	end
end 

