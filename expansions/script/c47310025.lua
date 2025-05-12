--面灵气 秦心※恋心
local s,id=GetID()
function s.sprule(c)
    c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,s.lcheck)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3ca0)
end
function s.tohand(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c,e,tp)
	return c:IsSetCard(0x3ca0) and c:IsFaceupEx() and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetMZoneCount(tp)>0))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.thfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local tg=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
        if tc:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
         and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_PUBLIC)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
	end
end
function s.todeck(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and r==REASON_LINK
end
function s.tdfilters(c,tp)
    return c:IsSetCard(0x3ca0) and c:IsFaceupEx() and c:IsAbleToDeck()
     and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilters,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg1=Duel.SelectTarget(tp,s.tdfilters,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,tg1)
    tg1:Merge(tg2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg1,#tg1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.draw(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.lffilter(c,tp)
    return c:IsSetCard(0x3ca0) and c:IsType(TYPE_EQUIP) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
end
function s.drfilter(c)
    return c:IsSetCard(0x3ca0) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.lffilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.eqcfilter(c,ec)
    return ec:CheckEquipTarget(c) and c:IsFaceup()
end
function s.eqfilter(c,tp)
    return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x3ca0) and Duel.IsExistingMatchingCard(s.eqcfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND,0,1,nil,tp)
     and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
        local ec=g:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g2=Duel.SelectMatchingCard(tp,s.eqcfilter,tp,LOCATION_MZONE,0,1,1,nil,ec)
        local eqc=g2:GetFirst()
        Duel.Equip(tp,ec,eqc)
    end
end
function s.initial_effect(c)
    s.sprule(c)
    s.tohand(c)
    s.todeck(c)
    s.draw(c)
end

