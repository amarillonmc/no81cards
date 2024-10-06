--渊猎的绳链

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
	--Activate
	--RemoveAndTargetTodeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
    --SetSelf
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	
	
	
end

--e1
--RemoveAndTargetTodeck

function s.todfilter(c,e)
    return aux.IsCodeListed(c,cid) and c:IsAbleToDeck()
    and c:IsCanBeEffectTarget(e)
    and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e) 
    if chk==0 then return g:CheckSubGroup(aux.dncheck,4,4) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
	
    Duel.SetTargetCard(sg)
	
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,4,0,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)	
    if not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rmg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
	
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

--e2
--SetSelf

function s.setcostfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsAbleToRemoveAsCost()
    and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())
end

function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.setcostfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.setcostfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_GRAVE_ACTION,c,1,0,LOCATION_GRAVE)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
    if not (tc:IsRelateToEffect(e) and tc:IsSSetable() and aux.NecroValleyFilter()(tc) and Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0) then return end
    Duel.SSet(tp,tc)
end


