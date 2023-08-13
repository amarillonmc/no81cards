--魔偶甜点·黑松露巧克力
local cm,m=GetID()

function cm.initial_effect(c)
    --sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x10)
    e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(42620060,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(cm.retcon)
	e7:SetTarget(cm.rettg)
	e7:SetOperation(cm.retop)
	c:RegisterEffect(e7)
end

function cm.costdfilter(c)
    return c:IsAbleToDeckOrExtraAsCost() and c:IsType(0x71) and c:IsRace(RACE_SPELLCASTER)
end

function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.costdfilter,tp,0x12,0,3,c) end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.costdfilter,tp,0x12,0,3,3,nil)
    if #g>0 then
        if g:IsExists(Card.IsLocation,1,nil,0x02) then
            Duel.ConfirmCards(1-tp,g:Filter(Card.IsLocation,nil,0x02))
        end
        Duel.SendtoDeck(g,nil,2,REASON_COST)
    end
end

function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end

function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,3,REASON_EFFECT)==3 then
        local c=e:GetHandler()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetTargetRange(0,LOCATION_SZONE)
        e2:SetReset(RESET_PHASE+PHASE_END)
        e2:SetTarget(cm.distarget)
        Duel.RegisterEffect(e2,tp)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_CHAIN_SOLVING)
        e3:SetReset(RESET_PHASE+PHASE_END)
        e3:SetOperation(cm.disoperation)
        Duel.RegisterEffect(e3,tp)
    end
end

function cm.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(0x6)
end

function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl,rp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(0x6) and rp==1-tp then
		Duel.NegateEffect(ev)
	end
end

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():IsPreviousControler(tp)
end

function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end