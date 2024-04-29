--爆裂场
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,80280737)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,80280737) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabel(1)
		e1:SetOperation(s.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(s.damcon)
		e2:SetOperation(s.damop)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.regfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x104f)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	if eg:IsExists(s.regfilter,1,nil,tp) then
		e:SetLabel(0)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.indtg(e,c)
	return c:IsSetCard(0x104f)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end