--守られているハンター
local cm,m=GetID()

function cm.initial_effect(c)
    aux.AddCodeList(c,34022290)
	--search
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e2:SetCost(cm.setcost)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --search
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x04)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
    --search
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(0x04)
    e5:SetCountLimit(1)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
end

function cm.costsfilter(c)
    return c:IsAbleToGraveAsCost() and c:GetType()==0x40002
end

function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costsfilter,tp,0x03,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costsfilter,tp,0x03,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function cm.tgsfilter(c)
    return c:IsSetCard(0x52) and c:IsAbleToHand() and c:IsType(0x1)
end

function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x01,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x01,0,1,1,nil)
	if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function cm.tgtfilter(c)
    return (c:IsType(0x1) or c:GetType()==0x40002) and c:IsAbleToDeck()
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x10) and cm.tgtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgtfilter,tp,0x10,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tgtfilter,tp,0x10,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToChain() and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
        Duel.SetLP(tp,Duel.GetLP(tp)-500)
    end
end

function cm.tgefilter2(c,tc)
    local ec=c:GetEquipTarget()
    return ec and ec~=tc and c:CheckEquipTarget(tc)
end

function cm.tgefilter(c)
    return c:IsCode(34022290) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.tgefilter2,0,0x08,0x08,1,nil,c)
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and cm.tgefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgefilter,tp,0x04,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.tgefilter,tp,0x04,0,1,1,nil)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToChain() then
        local g=Duel.GetMatchingGroup(cm.tgefilter2,0,0x08,0x08,nil,tc)
        if #g>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            g=g:Select(tp,1,#g,nil)
            if #g>0 then
                for ec in aux.Next(g) do
                    Duel.Equip(tp,ec,tc,true,true)
                end
                Duel.EquipComplete()
            end
        end
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetValue(1)
    Duel.RegisterEffect(e2,tp)
end