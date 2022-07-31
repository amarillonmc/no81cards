--魔导战舰 巨鲸号
function c9910918.initial_effect(c)
	aux.AddCodeList(c,9910871)
	c:EnableCounterPermit(0x1)
	c:SetUniqueOnField(1,0,9910918)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9910918.ctcon)
	e2:SetOperation(c9910918.ctop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9910918.target)
	e3:SetOperation(c9910918.operation)
	c:RegisterEffect(e3)
end
function c9910918.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re and aux.IsCodeListed(rc,9910871) and re:IsActiveType(TYPE_MONSTER)
end
function c9910918.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
function c9910918.spfilter(c,e,tp)
	if not (c:IsRace(RACE_SPELLCASTER+RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c9910918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x1,4,REASON_COST)
		and Duel.IsExistingMatchingCard(c9910918.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=Duel.IsCanRemoveCounter(tp,1,0,0x1,6,REASON_COST)
	if chk==0 then return b1 or b2 or b3 end
	local off=0
	local ops={}
	local opval={}
	off=1
	if b1 then
		ops[off]=aux.Stringid(9910918,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910918,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9910918,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
		Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	elseif opval[op]==2 then
		Duel.RemoveCounter(tp,1,0,0x1,4,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	else
		Duel.RemoveCounter(tp,1,0,0x1,6,REASON_COST)
		e:SetCategory(CATEGORY_LEAVE_GRAVE)
	end
end
function c9910918.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910918.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910918.setcon)
		e1:SetOperation(c9910918.setop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910918.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910918.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910918.setfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function c9910918.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910918)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910918.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
