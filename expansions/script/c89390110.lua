--破势兵·巨凿
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(s.chaincon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
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
function s.setfilter(c,tp)
	return c:IsSetCard(0xcd1) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(p,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,1-tp) end
	if Duel.GetCurrentChain()<4 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) end
end
function s.movefilter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,1-tp)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.IsExistingMatchingCard(s.movefilter,tp,0,LOCATION_MZONE,1,nil,1-tp) then
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
function s.rmfilter(c)
	return c:IsSetCard(0xcd1) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	if Duel.GetCurrentChain()<4 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local rc=g:GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		if Duel.Draw(tp,2,REASON_EFFECT)==2 and Duel.IsExistingMatchingCard(s.movefilter,tp,0,LOCATION_MZONE,1,nil,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
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
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
