local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,74620105)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.disfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsAbleToGraveAsCost()
end
function s.chkfilter(c,tp)
	return c:IsLevelAbove(8) and c:IsRace(RACE_MACHINE) and c:GetOwner()==tp
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return false end
	local sg=g:Filter(s.chkfilter,nil,tp)
	local mzone_g=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local freed=mzone_g:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local req=1+sg:GetCount()
	return ft+freed>=req
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local sg=g:Filter(s.chkfilter,nil,tp):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if sg:GetCount()>0 then
		sg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabelObject(sg)
		e1:SetOperation(s.spop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if eg:IsContains(e:GetOwner()) then
		e:Reset()
		local g=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if g:GetCount()>0 then
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft>0 then
				if g:GetCount()>ft then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					g=g:Select(tp,ft,ft,nil)
				end
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		sg:DeleteGroup()
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,74620105) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end