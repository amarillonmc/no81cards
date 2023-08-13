--魔偶甜点贵族·法奇软软糖
local cm,m=GetID()

function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x71),1,1)
    --sp
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(cm.valcheck)
	c:RegisterEffect(e4)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
    --destroy and summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(m)>0
end

function cm.tgsfilter(c,lv)
    return c:IsSetCard(0x71) and c:IsType(0x1) and c:IsLevel(lv)
end

function cm.tgsfilter2(c,type)
    return c:IsSetCard(0x71) and c:IsType(type) and c:IsAbleToHand()
end

function cm.tgsfilter3(c)
    return ((c:IsSetCard(0x71) and c:IsType(0x1)) or c:IsLocation(0x0c)) and c:IsAbleToDeck()
end

function cm.tgsfilter4(g)
    return g:GetClassCount(Card.GetLocation)==2
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local n=e:GetHandler():GetFlagEffectLabel(m)
    local b1=n==3 and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x01,0,1,nil,0x6)
    local b2=n==4 and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x01,0,1,nil,0x1)
    local b3=n==5 and Duel.GetMatchingGroup(cm.tgsfilter3,tp,0x10,0x0c,nil):CheckSubGroup(cm.tgsfilter4,2,2)
	if chk==0 then return b1 or b2 or b3 end
    if b1 or b2 then
        e:SetCategory(e:GetCategory()|CATEGORY_TOHAND+CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
    end
    if b3 then
        e:SetCategory(e:GetCategory()|CATEGORY_TODECK)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,0x1c)
    end
    e:SetLabel(n)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local n=e:GetLabel()
    if n==3 and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x01,0,1,nil,0x6) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x01,0,1,1,nil,0x6)
        if #sg>0 then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
    if n==4 and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x01,0,1,nil,0x1) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x01,0,1,1,nil,0x1)
        if #sg>0 then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
    if n==5 and Duel.GetMatchingGroup(cm.tgsfilter3,tp,0x10,0x0c,nil):CheckSubGroup(cm.tgsfilter4,2,2) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=Duel.GetMatchingGroup(cm.tgsfilter3,tp,0x10,0x0c,nil):SelectSubGroup(tp,cm.tgsfilter4,false,2,2)
        if #sg>0 then
            Duel.HintSelection(sg)
            Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        end
    end
end

function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end

function cm.tgtfilter(c)
	return c:IsSetCard(0x71) and c:IsAbleToDeck() and c:IsType(0x1)
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,0x10,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.tgtfilter,tp,0x10,0,nil)
	if dg:GetCount()>0 then
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
end

function cm.valcheck(e,c)
	local tc=e:GetHandler():GetMaterial():GetFirst()
	if tc:IsLevelAbove(1) and tc:IsSetCard(0x71) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,tc:GetLevel())
    else
        e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,0)
	end
end