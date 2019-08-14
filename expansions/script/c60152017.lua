--无法救赎的彼端
local m=60152017
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60152017+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60152017.target)
    e1:SetOperation(c60152017.activate)
    c:RegisterEffect(e1)
	--destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(aux.exccon)
    e2:SetCost(c60152017.descost)
    e2:SetTarget(c60152017.destg)
    e2:SetOperation(c60152017.activate2)
    c:RegisterEffect(e2)
end
function c60152017.filter(c)
    return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
        or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsReleasable()
end
function c60152017.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152017.filter,tp,LOCATION_MZONE,0,1,nil) end
    local sg=Duel.GetMatchingGroup(c60152017.filter,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()>0 then
		local atk=sg:GetSum(Card.GetAttack)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,atk)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
    end
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
end
function c60152017.filter2(c)
    if c:IsPreviousPosition(POS_FACEUP) then
        return c:GetPreviousAttackOnField()
    else return 0 end
end
function c60152017.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60152017.filter,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
        local og=Duel.GetOperatedGroup()
		local atk=og:GetSum(c60152017.filter2)
		Duel.Damage(tp,atk,REASON_EFFECT,true)
		Duel.Damage(1-tp,atk,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function c60152017.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60152017.filter3(c)
    return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c60152017.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152017.filter3,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152017.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c60152017.filter3,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
    end
end
