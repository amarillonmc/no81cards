local m=25000007
local cm=_G["c"..m]
cm.name="变形记"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp,mg)
	if c.mat_filter then mg=mg:Filter(c.mat_filter,c,tp) else mg:RemoveCard(c) end
	return c:IsType(TYPE_RITUAL) and not mg:IsExists(Card.IsRace,1,nil,c:GetRace()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and mg:GetCount()>0 and Duel.GetMZoneCount(tp,mg)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.rfilter2(c,e,tp)
	return cm.rfilter(c,e,tp) and not c:IsImmuneToEffect(e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:Select(tp,1,1,nil)
	if mat:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg):GetFirst()
	if sc then
		sc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			Duel.SpecialSummonComplete()
			sc:CompleteProcedure()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabelObject(sc)
			e3:SetCondition(cm.descon)
			e3:SetOperation(cm.desop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
