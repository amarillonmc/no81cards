--星流交汇★超跃星★安德露希·DualR
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),3,5,s.lcheck)
	c:EnableReviveLimit()
	--确认卡组    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--直接攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetCondition(s.exzcon)
	c:RegisterEffect(e2)
	--回到卡组    
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
    s.beyond_free_effect=e3    
end
function s.lkfilter(c)
	return c:IsLinkSetCard(0xca0) and c:IsLinkType(TYPE_LINK)
end    
function s.lcheck(g)
	return g:IsExists(s.lkfilter,1,nil)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if g1<5 or g2<5 then return end
    Duel.SortDecktop(tp,tp,5)
    Duel.SortDecktop(tp,1-tp,5)
    if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.exzcon(e)
	return e:GetHandler():GetSequence()>4
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,c)
end    
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
    Duel.SetChainLimit(s.chainlm)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.chainlm(re,rp,tp)
	return not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
	if tc then
    	Duel.HintSelection(Group.FromCards(tc))
        if Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0
        	and tc:IsLocation(LOCATION_REMOVED) then
            Duel.NegateEffect(0)
        	return                   
        end
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,tc)
        if g:GetCount()>0 then
        	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        end
    end
end