--封灵诅咒
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,11900061)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
    --To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
    e2:SetCondition(s.tdcon)
    e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
    e1:SetTarget(function(e,c,tp) 
    return c:GetControler()~=tp
        and (c:GetLocation()==0x01 or c:GetLocation()==0x02 or c:GetLocation()==0x10) end)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_REMOVE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetTarget(function(e,c,tp,r,re)   
	return re and r==REASON_EFFECT and c:IsFaceup() and c:IsLocation(0x0c)
        and (c:IsCode(11900061) or aux.IsCodeListed(c,11900061))
        and c:GetControler()~=tp end)
    e2:SetReset(RESET_PHASE+PHASE_END,1)
    Duel.RegisterEffect(e2,tp)
end
function s.tdfi1ter(c)
    return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.spfi1ter(c,pl)
	return c:IsControler(pl)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfi1ter,1,nil,e:GetHandlerPlayer())
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.Release(g,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfi1ter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.tdfi1ter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.tdfi2ter(c,e)
    return c:IsRelateToEffect(e) and c:IsAbleToDeck()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	local fg=g:Filter(s.tdfi2ter,nil,e)
    if #fg<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    local tc=fg:Select(tp,1,1,nil):GetFirst()
    if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 then
        local twe=fg:GetFirst()
        if twe==tc then twe=fg:GetNext() end
        Duel.SendtoDeck(twe,nil,0,REASON_EFFECT)
    end
end