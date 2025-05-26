--黄金螺旋-满溢“8”
local s,id=GetID()
function s.sprule(c)
    aux.AddLinkProcedure(c,s.mfilter,2,2,s.lcheck)
	c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,47380008)

    local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)

    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.zonelimit)
	c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:IsLinkType(TYPE_LINK)
end
function s.lcheck(g)
	return g:CheckWithSumEqual(Card.GetLinkMarker,0x1ef,2,2)
end
function s.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end
function s.linksummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.mgfilter(c)
	return c:IsType(TYPE_LINK) and c:GetLink()<=5
end
function s.rmfilter(c,lm)
	return c:IsAbleToRemove() and lm+c:GetLinkMarker()==0x1ef
end
function s.lfilter(c,mg,e,tp)
	if not s.mgfilter(c) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	 and mg:IsExists(s.rmfilter,1,c,c:GetLinkMarker())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_EXTRA,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg,e,tp)
    if #sg>0 then
        local tc=sg:GetFirst()
		local lm=tc:GetLinkMarker()
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			mg=mg:Filter(s.rmfilter,tc,lm)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=mg:Select(tp,1,1,nil)
			if #rg>0 then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
        end
	end
end
function s.draw(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id-1000)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.tdfilter(c)
    return c:IsType(TYPE_LINK) and c:IsAbleToExtra() and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and s.tdfilter(c) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and c:IsAbleToExtra()
		 and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,2,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local g=Group.FromCards(tc,e:GetHandler())
    local fg=g:Filter(Card.IsRelateToEffect,nil,e)
    if #fg>0 and Duel.SendtoDeck(fg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.initial_effect(c)
	s.sprule(c)
    s.linksummon(c)
    s.draw(c)
end

