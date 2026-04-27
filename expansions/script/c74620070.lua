local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(s.pcost)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.pcfilter(c,tp)
	if not c:IsType(TYPE_PENDULUM) then return false end
	local scl=c:GetLeftScale()
	return scl>=2 or c:IsReleasable()
end
function s.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(s.pcfilter,tp,LOCATION_PZONE,0,c,tp)
	if chk==0 then return tc end
	local scl=tc:GetLeftScale()
	if scl>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsLevel(2) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_ONFIELD)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if #g>0 and c:IsRelateToEffect(e) then
		g:AddCard(c)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(og)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.retfilter(c)
	return c:GetFlagEffect(id)>0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(s.retfilter,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(s.retfilter,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.ReturnToField(tc)
		end
	end
	e:GetLabelObject():DeleteGroup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.spfilter(c,e,tp)
	return c:GetBaseDefense()==2350 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		local ex_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c)
		local emz_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)
		local lz_ft=ex_ft-emz_ft
		local m_ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local b1=((emz_ft>0 and m_ft>0) or (lz_ft>0 and m_ft>=2)) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		local b2=(ex_ft>=2) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,c,e,tp)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ex_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	local emz_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)
	local lz_ft=ex_ft-emz_ft
	local m_ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=((emz_ft>0 and m_ft>0) or (lz_ft>0 and m_ft>=2)) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=(ex_ft>=2) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,c,e,tp)
	if not (b1 or b2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Group.CreateGroup()
	if b1 and not b2 then
		g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	elseif b2 and not b1 then
		g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,c,e,tp)
	else
		g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,c,e,tp)
	end
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end