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
function cm.rfilter(c,e,tp)
	return c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c,c:GetRace())
end
function cm.filter(c,e,tp,mc,rac)
	return c:IsType(TYPE_RITUAL) and not c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetMZoneCount(tp,mc)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.rfilter2(c,e,tp)
	return cm.rfilter(c,e,tp) and not c:IsImmuneToEffect(e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectReleaseGroup(tp,cm.rfilter2,1,1,nil,e,tp)
	if Duel.Release(rg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,nil,rg:GetFirst():GetRace()):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
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
			Duel.SpecialSummonComplete()
			sc:CompleteProcedure()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabelObject(sc)
			e1:SetCondition(cm.descon)
			e1:SetOperation(cm.desop)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
				e1:SetLabel(Duel.GetTurnCount())
				sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
				e1:SetLabel(0)
				sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
			end
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetLabel() then return false end
	return e:GetLabelObject():GetFlagEffect(m)>0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
