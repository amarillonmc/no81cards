--千星之心
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsReleasableByEffect()
		and (aux.IsCodeListed(c,id) or c:IsFaceup() and c:GetFlagEffect(id)~=0)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=c:GetLevel()
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function s.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and (aux.IsCodeListed(c,id) or c:GetFlagEffect(id)~=0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(id,2)
	opval[off-1]=3
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		local dt=tc:GetLevel()
		if Duel.Release(tc,REASON_EFFECT)==0 then return end
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,dt)
		local g=Duel.GetDecktopGroup(tp,dt)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,s.spfilter2,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				local sc=sg:GetFirst()
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
				g:Sub(sg)
			else
				return
			end
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		local gg=Duel.GetOperatedGroup()
		for gc in aux.Next(gg) do
			gc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end