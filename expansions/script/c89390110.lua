--破势兵·巨凿
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(s.chaincon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>2 or Duel.GetFlagEffect(tp,id)==0
end
function s.filter(c,mg)
	return c:IsFacedown() and c:IsCode(89390101,89390103,89390107,89390109) and mg:IsExists(s.gcheck,1,nil,c)
end
function s.gcheck(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and c:IsLevel(3) and c:IsAbleToRemove()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	if Duel.GetCurrentChain()<4 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) end
end
function s.movefilter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=mg:FilterSelect(tp,s.gcheck,1,1,nil,tc)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.movefilter,tp,0,LOCATION_MZONE,1,nil,1-tp) then
			local mg=Duel.SelectMatchingCard(tp,s.movefilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp)
			local seq=mg:GetFirst():GetSequence()
			local flag=0
			if seq>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
			if seq<4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,~flag<<16)
			local nseq=math.log(s,2)
			Duel.MoveSequence(mg:GetFirst(),nseq-16)
		end
	end
end
function s.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local zone=0
		local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		for tc in aux.Next(lg) do
			zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
		end
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	if zone>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
