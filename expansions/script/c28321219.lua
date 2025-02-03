--线条们的十二月
function c28321219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c28321219.condition)
	e1:SetTarget(c28321219.target)
	e1:SetOperation(c28321219.activate)
	c:RegisterEffect(e1)
end
function c28321219.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c28321219.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28321219.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28321219.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetMZoneCount(tp)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_WATER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c28321219.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c28321219.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_WATER,ATTRIBUTE_DARK)
	if #sg~=2 then return end
	local lc=sg:Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK):GetFirst()
	local hc=sg:Filter(Card.IsAttribute,nil,ATTRIBUTE_WATER):GetFirst()
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local fid=e:GetHandler():GetFieldID()
	--luka
	lc:RegisterFlagEffect(28321219,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(28321219,0))
	local e1=Effect.CreateEffect(lc)
	e1:SetDescription(aux.Stringid(28321219,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(lc)
	e1:SetCondition(c28321219.regcon)
	e1:SetOperation(c28321219.rmop)
	Duel.RegisterEffect(e1,tp)
	--hiori
	hc:RegisterFlagEffect(28321219,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(28321219,1))
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(28321219,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(hc)
	e2:SetCondition(c28321219.regcon)
	e2:SetOperation(c28321219.posop)
	Duel.RegisterEffect(e2,tp)
end
function c28321219.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(28321219)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c28321219.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28321219)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c28321219.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28321219)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end
