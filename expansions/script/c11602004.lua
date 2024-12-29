--海爬兽宝宝 小蛇颈

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--ExtraGraveToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--NegateSpAndTrap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

end

--e1
--ExtraGraveToHand

function s.e1tohfilter(c)
    local bl=c:IsSetCard(zd) and c:IsAbleToHand()
    if c:IsLocation(LOCATION_EXTEA) then
        return bl and c:IsFaceup()
    else
        return bl
    end
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_EXTRA+LOCATION_GRAVE)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)	
    if not (Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e1tohfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e1tohfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end

--e2
--NegateSpAndTrap

function s.e2confilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,1,nil) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
