local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,74620105)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,s.ffilter,3,99,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	c:SetUniqueOnField(1,0,id,LOCATION_MZONE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.damval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsLevel(8) and c:IsRace(RACE_MACHINE)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler())
end
function s.tdfilter(c)
	return c:IsLevel(8) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function s.spfilter2(c,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,74620105)
	local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if rg:GetCount()==0 or tdg:GetCount()==0 then return false end
	return rg:IsExists(s.spfilter2,1,nil,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,74620105):Filter(s.spfilter2,nil,tp,c)
	local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if rg:GetCount()>0 and tdg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=rg:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=tdg:Select(tp,1,3,nil)
		g1:Merge(g2)
		g1:KeepAlive()
		e:SetLabelObject(g1)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local tc=g:Filter(Card.IsCode,nil,74620105):GetFirst()
	local tdg=g:Clone()
	tdg:RemoveCard(tc)
	Duel.Release(tc,REASON_SPSUMMON)
	Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.damval(e,re,val,r,rp,rc)
	if Duel.IsBattlePhase() then
		return 0
	end
	return val
end