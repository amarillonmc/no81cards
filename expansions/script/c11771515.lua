--混沌之传道者
local s,id,o=GetID()
function c11771515.initial_effect(c)
		aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcf),aux.NonTuner(Card.IsSetCard,0xcf),1)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(s.rmcon)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69248256,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771500,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.sptg1)
	e3:SetOperation(s.spop1)
	c:RegisterEffect(e3)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end
function s.rmcon(e)
	return Duel.GetFlagEffect(0,id)>0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.filter(c)
	return c:IsSetCard(0xcf) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToRemove() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--
function s.filter1(c,e,tp)
	return c:IsSetCard(0xcf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter2(c)
local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	return c:IsSetCard(0xcf) and c:IsSynchroSummonable(nil,g)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,nil,REASON_EFFECT)>0 then
		if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)) then return end
		local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>1 
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil) 
and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
	end
end
end













