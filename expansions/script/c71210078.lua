--码丽丝<王后>黑桃侵蚀
function c71210078.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c71210078.lcheck)
	c:EnableReviveLimit()   
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71210078) 
	e1:SetCost(c71210078.spcost1)
	e1:SetTarget(c71210078.sptg1)
	e1:SetOperation(c71210078.spop1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e2:SetTarget(c71210078.distg) 
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11210078)
	e3:SetCost(c71210078.spcost)
	e3:SetTarget(c71210078.sptg)
	e3:SetOperation(c71210078.spop)
	c:RegisterEffect(e3)
end
function c71210078.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1bf)
end
function c71210078.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsDiscardable() and c:IsSetCard(0x1bf) end,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,function(c) return c:IsDiscardable() and c:IsSetCard(0x1bf) end,1,1,REASON_COST+REASON_DISCARD)
end
function c71210078.spfilter1(c,e,tp,zone)
	return c:IsRace(RACE_CYBERSE) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71210078.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c71210078.spfilter1,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c71210078.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71210078.spfilter1,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c71210078.distg(e,c)  
	local tp=e:GetHandlerPlayer() 
	local x=0
	local g=Duel.GetMatchingGroup(function(c) return c:IsSetCard(0x1bf) and c:IsType(TYPE_LINK) end,tp,LOCATION_MZONE,0,nil) 
	local tc=g:GetFirst() 
	while tc do 
	if tc:GetLinkedGroup():IsContains(c) then 
		x=x+1
	end 
	tc=g:GetNext()
	end
	if x>0 then return true end 
end
function c71210078.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,900) end
	Duel.PayLPCost(tp,900)
end
function c71210078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71210078.setfil(c)
	return c:IsSSetable() and c:IsSetCard(0x1bf) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c71210078.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c71210078.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(71210078,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c71210078.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc then
			Duel.SSet(tp,tc)
		end
	end
end

