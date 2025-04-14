--閃刀姫＝ゼロ
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9d3),2,2)
	--link limit
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0x9d3) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGrave() and   c:CheckActivateEffect(true,true,false)~=nil
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
	local b2=c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c,tp)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)  and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)	 and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)   and Duel.GetFlagEffect(tp,id+1)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
	local b2=c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c,tp)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)  and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)	 and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)   and Duel.GetFlagEffect(tp,id+1)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
			Duel.SendtoGrave(g,REASON_EFFECT)
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	else
		Duel.Release(c,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if #g1>=1 and #g2>=1 then
			g1:Merge(g2)
			local sg=g1:SelectSubGroup(tp,s.fselect,false,2,2)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.spfilter1(c,e,tp)
	return c:IsCode(91030019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
	return c:IsCode(91030020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==2
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 
	c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),tp)
	local cg1=cg:Select(tp,1,1,c) 
	cg1:AddCard(c)
	Duel.Remove(cg1,POS_FACEUP,REASON_COST)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x9d3) and c:IsAbleToRemoveAsCost()  and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,c)
end
function s.thfilter(c,tp)
	return c:IsSetCard(0x9d3) and c:IsType(TYPE_SPELL) and c:IsSSetable() and c:IsType(TYPE_QUICKPLAY)	 
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		--Duel.ConfirmCards(1-tp,g)
	end
end

