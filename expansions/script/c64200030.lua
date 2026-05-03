--仿制型XIII “降灵” 爱妮慕丝
local s,id,o=GetID()
function s.initial_effect(c)
	--不用解放	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--盲堆    
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END+TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
    e3:SetCondition(s.tgcon)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE,0)>=5
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
    	and Duel.GetTurnPlayer()==tp
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and not (c:IsAttribute(ATTRIBUTE_DARK) or c:IsLevel(7))
    	and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(7)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local tg=g:Filter(aux.NecroValleyFilter(s.cfilter),nil)
    if tg:GetCount()>0 then
    	Duel.BreakEffect()
        Duel.ConfirmCards(tp,tg)
        Duel.HintSelection(tg)
        Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
    end     
    if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=13 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
       	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
           	Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)        	
        end
    end
end