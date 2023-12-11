--黑衣执事 夏尔丹
local s,id=GetID()
function s.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1)
	c:EnableReviveLimit()
	 --检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.poscon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)	
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(2)and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)   
	end

end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.spfilter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function s.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) 
end
function s.synfilter(c,g)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FIEND) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local g=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_REMOVED,0,e:GetHandler(),e,tp)
	local b1=g:CheckSubGroup(s.fselect1,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and b1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.fselect1,false,1,ft,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function s.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.spfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	local tg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
	end
end
