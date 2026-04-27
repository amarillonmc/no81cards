--黄昏之城
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCondition(s.indescon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_REMOVE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,1)
	e12:SetTarget(s.rmlimit)
	e12:SetCondition(s.indescon)
	c:RegisterEffect(e12)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+o*100)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_REMOVE)
end
function s.filter(c)
	return c:IsLevel(7) and c:IsRace(RACE_DRAGON) and c:IsAbleToRemove()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.indescon(e)
	return Duel.IsExistingMatchingCard(s.dfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.rmlimit(e,c,tp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function s.ifilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.indescon(e)
	return Duel.IsExistingMatchingCard(s.ifilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_DRAGON)
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED)
		and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)

end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(s.cfilter,1,nil,e,tp)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,s.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end