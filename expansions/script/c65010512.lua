--URBEX HINDER-渡鸦
function c65010512.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c65010512.lcheck)
	c:EnableReviveLimit()
	--spsum
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010512)
	e1:SetTarget(c65010512.tg)
	e1:SetOperation(c65010512.op)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65010513)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65010512.spcon)
	e2:SetCost(c65010512.spcost)
	e2:SetTarget(c65010512.sptg)
	e2:SetOperation(c65010512.spop)
	c:RegisterEffect(e2)
end
c65010512.setname="URBEX"
function c65010512.lcfil(c)
	return c.setname=="URBEX"
end
function c65010512.lcheck(g)
	return g:IsExists(c65010512.lcfil,1,nil) 
end
function c65010512.spfilter1(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,1-tp,zone)
end
function c65010512.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(1-tp)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(c65010512.spfilter1,1-tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65010512.op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(1-tp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(c65010512.spfilter1,1-tp,LOCATION_EXTRA,0,nil,e,tp,zone)
	local sg=g:RandomSelect(1-tp,1)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP,zone)
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end


function c65010512.spcfilter(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return  ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c65010512.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010512.spcfilter,1,nil,tp,e:GetHandler())
end
function c65010512.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==2
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010512.spfilter(c,e,tp)
	return c.setname=="URBEX" and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65010512.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c65010512.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65010512.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65010512.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end