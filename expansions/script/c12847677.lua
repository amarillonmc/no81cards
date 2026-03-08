--天魔之调整士-玛那
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.cfilter(c,rc)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		if bit.band(loc,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)==0 then return false end
		return Duel.IsExistingMatchingCard(s.cfilter,tp,loc,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.syfilter(c,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mg)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,loc,0,1,1,c)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			--synchro custom
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SPSUM_PARAM)
			e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sg:GetFirst():RegisterEffect(e1,true)
			local mg=Group.FromCards(c,sg:GetFirst())
			local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				local tc=g:Select(tp,1,1,nil):GetFirst()
				Duel.SynchroSummon(tp,tc,nil,mg)
			end
		end
	end
end