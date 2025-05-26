--黄金螺旋-半合“34”
local s,id=GetID()
function s.draw(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.confilter(c,tp)
    return c:IsSetCard(0xcc13) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetPreviousTypeOnField()&TYPE_LINK~=0
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.confilter,1,nil,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdfilter(c)
    return c:IsType(TYPE_LINK) and c:IsFaceupEx() and c:IsAbleToExtra()
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsSetCard(0xcc13) and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
         and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local tg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
            Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		    Duel.ShuffleHand(tp)
         end
	end
end
function s.lvdown(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
    e1:SetCondition(s.ldcon)
	e1:SetTarget(s.ldtg)
	e1:SetOperation(s.ldop)
	c:RegisterEffect(e1)
end
function s.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcc13) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.ldcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.spfilter,1,nil)
end
function s.ldfilter(c)
    return c:IsFaceup() and c:IsLevelAbove(2)
end
function s.ldtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ldfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.maxfilter(c)
    if c:GetLink()>0 then return c:GetLink() end
    return 0
end
function s.ldhandle(c,e,lc)
    local lv=c:GetLevel()
    if lv<=lc then
        lv=lv-1
    else
        lv=lc
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetValue(-lv)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end
function s.ldop(e,tp,eg,ep,ev,re,r,rp)
	local mg,maxl=eg:GetMaxGroup(s.maxfilter)
    local g=Duel.GetMatchingGroup(s.ldfilter,tp,0,LOCATION_MZONE,nil)
    g:ForEach(s.ldhandle,e,maxl)
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    s.draw(c)
    s.lvdown(c)
end
