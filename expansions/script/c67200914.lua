--废都雷狼
function c67200914.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200914,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67200914)
	e2:SetCondition(c67200914.spcon)
	e2:SetTarget(c67200914.sptg)
	e2:SetOperation(c67200914.spop)
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200914,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,67200915)
	e3:SetCondition(c67200914.descon)
	e3:SetTarget(c67200914.destg)
	e3:SetOperation(c67200914.desop)
	c:RegisterEffect(e3)	 
end
function c67200914.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(67200912,PLAYER_ALL,LOCATION_FZONE)
end
function c67200914.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200914.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
---
function c67200914.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c67200914.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200914.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetOperation(c67200914.desop1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e1,tp)
end
function c67200914.filter1(c,e,tp)
	return c:IsCode(67200914) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200914.filter2(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return not c:IsType(TYPE_TUNER) and c:IsSetCard(0x967b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c67200914.scfilter2,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c67200914.spfilter2(c,mg)
	return c:IsSynchroSummonable(nil,mg,mg:GetCount()-1,mg:GetCount()-1)
end
function c67200914.desop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.IsExistingMatchingCard(c67200914.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c67200914.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(67200914,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200914.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local sc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c67200914.filter2,tp,LOCATION_GRAVE,0,1,1,sc,e,tp,sc)
		g:Merge(g2)
		local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local syg=Duel.GetMatchingGroup(c67200914.spfilter2,tp,LOCATION_EXTRA,0,nil,g)
		if ct>=2 and syg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=syg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,g,g:GetCount()-1,g:GetCount()-1)
		end
	end
end

