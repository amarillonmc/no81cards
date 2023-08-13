--魔偶甜点堡主·城堡美容师
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
    --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end

function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_BEAST)
end

function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function cm.costdfilter(c)
    return c:IsAbleToHandAsCost() and c:IsSetCard(0x71)
end

function cm.costdfilter2(c,g)
    return g:IsContains(c)
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local fg=Duel.GetMatchingGroup(cm.costdfilter,tp,0x0c,0,nil)
    local xyzg=c:GetOverlayGroup()
    local ng=fg:Clone()
    if c:CheckRemoveOverlayCard(tp,1,REASON_COST) then
        ng:Merge(xyzg)
    end
	if chk==0 then return #ng>=2 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    ng=ng:Select(tp,2,2,nil)
    if #xyzg>0 then
        Duel.SendtoGrave(ng:Filter(cm.costdfilter2,nil,xyzg),REASON_COST)
    end
    local hg=ng:Filter(cm.costdfilter2,nil,fg)
    if #hg>0 then
        Duel.SendtoHand(hg,nil,REASON_COST)
        Duel.ConfirmCards(1-tp,hg)
    end
end

function cm.tgdfilter(c)
    return c:IsAbleToDeck() and c:IsType(0x1)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgdfilter,tp,0x12,0,1,nil) and Duel.GetFieldGroupCount(tp,0,0x40)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x50,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x12)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,0x50)
end

function cm.opdfilter(c)
    return not c:IsLocation(0x40)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.tgdfilter,tp,0x12,0,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        if tc:IsLocation(0x02) then
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.HintSelection(g)
        end
        if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
            if tc:IsLocation(0x01) then
                Duel.ShuffleDeck(tc:GetControler())
            end
            local rg=Duel.GetFieldGroup(tp,0,0x40)
            if #rg>0 then
                Duel.ConfirmCards(tp,rg)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,0x50,1,2,nil)
                if #sg>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) and sg:IsExists(cm.opdfilter,1,nil) then
                    Duel.ShuffleExtra(1-tp)
                end
            end
        end
    end
end