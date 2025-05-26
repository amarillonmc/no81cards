--黄金螺旋-全方“144”
local s,id=GetID()
function s.spsummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rmfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.pbfilter(c,e,tp)
	return c:IsSetCard(0xcc13) and c:IsType(TYPE_LINK) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
     and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,c:GetLink(),nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pbfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local tg=Duel.SelectMatchingCard(tp,s.pbfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,tg)
    local lc=tg:GetFirst()
    e:SetLabelObject(lc)
    lc:CreateEffectRelation(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pbfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,e:GetLabelObject():GetLink(),0,LOCATION_GRAVE)
end
function s.tgfilter(c,lmc)
    return c:IsType(TYPE_LINK) and c:IsLinkBelow(lmc) and c:IsAbleToGrave()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)

	local lc=e:GetLabelObject()
    local lmc=lc:GetLink()
    if Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,lmc,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,lmc,lmc,nil)
        if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 and lc:IsRelateToEffect(e)
         and  Duel.SpecialSummon(lc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
            lc:CompleteProcedure()
            if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_EXTRA,0,1,nil,lmc)
             and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                local tgg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,lmc)
                Duel.SendtoGrave(tgg,REASON_EFFECT)
            end
        end
    end
end
function s.splimit(e,c)
	return not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA)
end
function s.todeck(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id-1000)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
function s.tdfilter(c)
    return not c:IsCode(47380144) and (c:IsSetCard(0xcc13) or c:GetOriginalType()&(TYPE_LINK+TYPE_MONSTER)==TYPE_LINK+TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_REMOVED,0,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,tg,#tg,LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local rg=g:Filter(Card.IsRelateToEffect,nil,e)
    if #rg>0 then
        Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end
function s.initial_effect(c)
    s.spsummon(c)
    s.todeck(c)
end
