--艾力兽
function c9951581.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951581,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9951581)
	e2:SetCost(c9951581.spcost)
	e2:SetTarget(c9951581.sptg)
	e2:SetOperation(c9951581.spop)
	c:RegisterEffect(e2)
end
function c9951581.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9951581.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951581.filter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c9951581.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9951581.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetMZoneCount(tp,e:GetHandler())>1 and g:IsExists(c9951581.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c9951581.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c9951581.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c9951581.filter2,nil,g)
	if dg:GetCount()>=1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:RemoveCard(tc1)
		local tc2=dg:Filter(Card.IsCode,nil,tc1:GetCode()):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(9951581,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc2:RegisterFlagEffect(9951581,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		Duel.SpecialSummonComplete()
		sg:AddCard(tc2)
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		e1:SetCondition(c9951581.descon)
		e1:SetOperation(c9951581.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9951581.desfilter(c,fid)
	return c:GetFlagEffectLabel(9951581)==fid
end
function c9951581.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9951581.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9951581.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c9951581.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end

