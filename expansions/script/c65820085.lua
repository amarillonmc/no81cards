--源于黑影 空壳
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(s.sprcon)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.speop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.tnop)
	c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.sprfilter(c, sc)
    local tp = sc:GetControler()
    if not c:IsSetCard(0x3a32) then return false end
    local has_use = Duel.GetFlagEffect(tp, 65820099) > 0
    local is_flipped = sc:GetFlagEffect(65820010) > 0
    if c:IsLocation(LOCATION_MZONE) then
        return c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
    end
    if c:IsLocation(LOCATION_SZONE) then
        return (not has_use and not is_flipped) or (has_use and is_flipped)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        if not c:IsCanBeXyzMaterial(sc) then return false end
        return (has_use and not is_flipped) or (not has_use and is_flipped)
    end
    return false
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,c,c)
	return g:CheckSubGroup(s.spgckfil,2,2,e,tp)
end

function s.spgckfil(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,nil)>0
end

function s.spfilter1(c)
	return c:GetFlagEffect(id)>0
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,c,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,s.spgckfil,false,2,2,e,tp)
	local has_extra=sg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA)
	if has_extra then
		s.consume_use_counter(e,tp)
		local tc=sg:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_EXTRA) then
				tc:RegisterFlagEffect(id,0,EFFECT_FLAG_SET_AVAILABLE,1)
			end
			tc=sg:GetNext()
		end
	end
	local og=Group.CreateGroup()
	local tc=sg:GetFirst()
	while tc do
		local og1=tc:GetOverlayGroup()
		og:Merge(og1)
		tc=sg:GetNext()
	end
	Duel.SendtoGrave(og,REASON_RULE)
	local tc2=sg:GetFirst()
	while tc2 do
		if not tc2:IsLocation(LOCATION_EXTRA) then
			c:SetMaterial(Group.FromCards(tc2))
			Duel.Overlay(c,Group.FromCards(tc2))
		end
		tc2=sg:GetNext()
	end
end

function s.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	local g=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_EXTRA,0,c)
	if #g==0 then return end
	if c:IsLocation(LOCATION_MZONE) then
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	else
		Duel.SendtoGrave(g,REASON_RULE)
	end
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(id)
		tc=g:GetNext()
	end
end

function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(s.descon1)
	e2:SetOperation(s.desop1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	end
	return true
end

function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function s.filter(c)
	return c:IsAbleToDeckOrExtraAsCost()
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if chk==0 then return #mg>0 or Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,0,#mg+1,nil)
	Duel.HintSelection(g)
	local g1=g+mg
	if #g1>0 then
		e:SetLabel(g1:GetCount())
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabel() then return end
	local count=e:GetLabel()*1000
	Duel.SetLP(tp,Duel.GetLP(tp)-count)
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
	end
end