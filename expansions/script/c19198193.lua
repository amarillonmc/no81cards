--空牙团的疾风 格雷
function c19198193.initial_effect(c)  
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c19198193.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(c19198193.splimcon)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19198193) 
	e2:SetTarget(c19198193.sptg) 
	e2:SetOperation(c19198193.spop) 
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19198193,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,29198193)
	e3:SetCost(c19198193.descost)
	e3:SetTarget(c19198193.destg)
	e3:SetOperation(c19198193.desop)
	c:RegisterEffect(e3)
end
function c19198193.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x114) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c19198193.splimcon(e)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) 
end 
function c19198193.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x114)   
end  
function c19198193.spgck(g)  
	return g:GetClassCount(Card.GetCode)==g:GetCount()  
end 
function c19198193.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c19198193.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and g:CheckSubGroup(c19198193.spgck,2,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end 
function c19198193.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198193.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and g:CheckSubGroup(c19198193.spgck,2,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
	local sg=g:SelectSubGroup(tp,c19198193.spgck,false,2,2) 
	Duel.ConfirmCards(1-tp,sg) 
	local sc1=sg:Select(1-tp,1,1,nil):GetFirst() 
	sg:RemoveCard(sc1) 
	local sc2=sg:GetFirst()  
	Duel.SpecialSummonStep(sc1,0,tp,1-tp,false,false,POS_FACEUP) 
	Duel.SpecialSummonStep(sc2,0,tp,tp,false,false,POS_FACEUP) 
	Duel.SpecialSummonComplete() 
	end 
end  
function c19198193.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c19198193.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19198193.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end












