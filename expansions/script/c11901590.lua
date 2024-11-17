--星光佳节
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --Chain Limit
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetRange(LOCATION_FZONE)
    e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.ciop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0x3c,0x3c)
	e2:SetTarget(s.actg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
    --ToDeck and SpSum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
    --ToDeck and Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return end
	local c=e:GetHandler() 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if #g>0 then
        local tc=g:GetFirst()
        while tc do
            if tc:GetFlagEffect(id)==0 then
                tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
            end
            tc=g:GetNext()
        end
	end
end
function s.actg(e,c)
	return c:GetFlagEffect(id)>0
end
function s.thfilter(c,code)
	return c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and not c:IsOriginalCodeRule(code)
end
function s.tdfilter(c,tp)
	return c:IsAbleToDeck() and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsFaceup()
        and Duel.IsExistingMatchingCard(s.thfilter,tp,0x01,0,1,nil,c:GetOriginalCodeRule()) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,0x0c,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,507)
	local tg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,0x0c,0,1,1,nil,e,tp)
    if #tg>0 then
        Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(0x41) then return end
        local code=tc:GetOriginalCodeRule()
		Duel.Hint(3,tp,506)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,0x01,0,1,1,nil,code)
		if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,0x40)
            Duel.ConfirmCards(1-tp,g)
        end
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    c=e:GetHandler()
    if chk==0 then return c:IsLocation(0x30) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,0x40)>0 and c:IsLocation(0x01) then
        Duel.Draw(tp,1,0x40)
    end
end