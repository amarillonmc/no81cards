--源于黑影 俱伤
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CUSTOM+65820000)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(s.spcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
    c:RegisterEffect(e2)
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(id,1))
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetRange(LOCATION_GRAVE)
		e4:SetCost(aux.bfgcost)
		e4:SetTarget(s.tdtg)
		e4:SetOperation(s.tdop)
		c:RegisterEffect(e4)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not g or #g~=2 then return end

    local c1=g:GetFirst()
    local c2=g:GetNext()

    if not c1:IsRelateToEffect(e) or not c2:IsRelateToEffect(e) then return end
    if not c1:IsFaceup() or not c2:IsFaceup() then return end
		local atk1=c1:GetAttack()
		local atk2=c2:GetAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetTargetRange(1,1)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)

    Duel.HintSelection(Group.FromCards(c1,c2))
    Duel.CalculateDamage(c1,c2,true)

    local atk_diff=math.abs(atk1-atk2)
    local lp_cost=atk_diff*2

    if lp_cost>0 then
        Duel.SetLP(tp,Duel.GetLP(tp)-lp_cost)
        if Duel.GetLP(tp)<=0 then
            Duel.SetLP(tp,4000)
            Duel.RaiseEvent(c,EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
        end
    end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(function(c) return c:IsSetCard(0x3a32) end,1,nil,tp) and ep==tp
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,3,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
		local flip=0
    for tc in aux.Next(g) do
        if tc.effect_lixiaoguo then
            if tc:GetFlagEffect(65820010)==0 then
                tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
            else
                tc:ResetFlagEffect(65820010)
            end
						flip=1
        end
    end
		if flip==1 then
    	Duel.RaiseEvent(g,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
		end
end