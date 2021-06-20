--星辉之星蝶
function c9910065.initial_effect(c)
	c:SetUniqueOnField(1,0,9910239)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9910065.descon1)
	e2:SetOperation(c9910065.desop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetCondition(c9910065.descon2)
	e5:SetOperation(c9910065.desop2)
	c:RegisterEffect(e5)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c9910065.desreptg)
	e6:SetValue(c9910065.desrepval)
	e6:SetOperation(c9910065.desrepop)
	c:RegisterEffect(e6)
end
function c9910065.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1
end
function c9910065.desfilter(c,tc)
	local seq=tc:GetSequence()
	local loc=tc:GetLocation()
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	local lg=tc:GetColumnGroup()
	local mg=Duel.GetFieldGroup(tc:GetControler(),LOCATION_MZONE,0)
	local sg=Duel.GetFieldGroup(tc:GetControler(),LOCATION_SZONE,0)
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if loc==LOCATION_SZONE and seq>=5 then return false end
	if loc==LOCATION_MZONE and seq>=5 then return c:IsLocation(LOCATION_MZONE) and lg:IsContains(c) end
	if loc==LOCATION_SZONE and seq<=4 then
		return (mg:IsContains(c) and lg:IsContains(c) and cseq<=4)
			or (sg:IsContains(c) and math.abs(cseq-seq)==1)
	end
	if loc==LOCATION_MZONE and seq<=4 then
		return (sg:IsContains(c) and lg:IsContains(c)) or (cseq>=5 and lg:IsContains(c))
			or (mg:IsContains(c) and math.abs(cseq-seq)==1 and cseq<=4)
	end
	return false
end
function c9910065.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsOnField() then return end
	local g=Duel.GetMatchingGroup(c9910065.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,9910065)
	Duel.HintSelection(g)
	local oc=Duel.Destroy(g,REASON_EFFECT)
	if oc==0 or not tc:IsCanAddCounter(0x1951,oc) then return end
	tc:AddCounter(0x1951,oc)
end
function c9910065.descon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rc and rc:GetSequence()<=4
end
function c9910065.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsOnField() then return end
	local g=Duel.GetMatchingGroup(c9910065.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,9910065)
	Duel.HintSelection(g)
	local oc=Duel.Destroy(g,REASON_EFFECT)
	if oc==0 or not tc:IsCanAddCounter(0x1951,oc) then return end
	tc:AddCounter(0x1951,oc)
end
function c9910065.repfilter(c,tp)
	return c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x1951,1,REASON_EFFECT)
end
function c9910065.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c9910065.repfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	e:SetLabelObject(g)
	return true
end
function c9910065.desrepval(e,c)
	return c9910065.repfilter(c,e:GetHandlerPlayer())
end
function c9910065.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910065)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	while tc do
		tc:RemoveCounter(tp,0x1951,1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tc:GetControler(),1,REASON_EFFECT)
		tc=g:GetNext()
	end
end
