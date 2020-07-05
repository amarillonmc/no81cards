--维多利亚·狙击干员-梅
function c79029133.initial_effect(c)
	--limit
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029133+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c79029133.actop)
	c:RegisterEffect(e1)   
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029133.condition)
	e2:SetOperation(c79029133.activate)
	c:RegisterEffect(e2)
end
function c79029133.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp/2)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetOperation(c79029133.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c79029133.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
end
function c79029133.rmfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c79029133.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c79029133.rmfilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace())
end
function c79029133.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=1,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
		local race=1
		while bit.band(RACE_ALL,race)~=0 do
			local rg=g:Filter(Card.IsRace,nil,race)
			local rc=rg:GetCount()
			if rc>1 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				sg:Merge(dg)
			end
			race=race*2
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end
function c79029133.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end
function c79029133.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c79029133.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,tc)
	if Duel.IsCanRemoveCounter(tp,1,0,0x1099,4,REASON_COST) and  Duel.CheckLPCost(tp,1000) then
	if Duel.SelectYesNo(tp,aux.Stringid(1050186,0)) then
	Duel.RemoveCounter(tp,1,0,0x1099,4,REASON_COST)
	Duel.PayLPCost(tp,1000) 
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
end
end
end
end













