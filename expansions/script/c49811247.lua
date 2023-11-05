--星騎士 天竜星
function c49811247.initial_effect(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811247,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811247)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
    e1:SetTarget(c49811247.sptg)
    e1:SetOperation(c49811247.spop)
    c:RegisterEffect(e1)
    --return or be material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811247,2))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,49811248)
--    e2:SetCondition(c49811247.lgcon)
    e2:SetTarget(c49811247.lgtg)
    e2:SetOperation(c49811247.lgop)
    c:RegisterEffect(e2)
end
function c49811247.spfilter(c,e,tp)
    return (c:IsSetCard(0x9e) or c:IsSetCard(0x9c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c49811247.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(c49811247.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c49811247.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c49811247.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local sc=g:GetFirst()
        if sc then
            if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) ~= 0 then
            	local e1=Effect.CreateEffect(c)
            	e1:SetDescription(aux.Stringid(49811247,1))
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
                e1:SetCode(EFFECT_IMMUNE_EFFECT)
                e1:SetRange(LOCATION_MZONE)
                e1:SetValue(c49811247.immval)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e1,true)
            end
        end
    end
end
function c49811247.immval(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActivated()
end
function c49811247.lgfilter1(c)
    return c:IsFaceup() and (c:IsSetCard(0x9e) or c:IsSetCard(0x9c)) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c49811247.lgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811247.lgfilter1,tp,LOCATION_MZONE,0,1,nil) 
end
function c49811247.lgfilter2(c)
    return (c:IsSetCard(0x9e) or c:IsSetCard(0x9c)) and c:IsAbleToDeck()
end
function c49811247.lgfilter3(c)
    return (c:IsSetCard(0x9e) or c:IsSetCard(0x9c)) and c:IsCanOverlay()
end
function c49811247.lgfilter4(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_XYZ)
end
function c49811247.lgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
   	if chkc then
        if e:GetLabel()==0 then
            return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c49811247.lgfilter2(chkc) and chkc~=c
        else
            return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c49811247.lgfilter3(chkc) and chkc~=c
        end
    end
    local b1=Duel.IsExistingTarget(c49811247.lgfilter2,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToDeck()
    local b2=Duel.IsExistingTarget(c49811247.lgfilter3,tp,LOCATION_GRAVE,0,1,c) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(c49811247.lgfilter4,tp,LOCATION_MZONE,0,1,nil)
    if chk==0 then return (b1 or b2) end
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(49811247,3),aux.Stringid(49811247,4))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(49811247,3))
    else
        op=Duel.SelectOption(tp,aux.Stringid(49811247,4))+1
    end
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_TODECK)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectTarget(tp,c49811247.lgfilter2,tp,LOCATION_GRAVE,0,1,2,c)
        Group.AddCard(g,c)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g=Duel.SelectTarget(tp,c49811247.lgfilter3,tp,LOCATION_GRAVE,0,1,2,c)
    end
end
function c49811247.lgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if not (tg:GetCount()>0 and c:IsRelateToEffect(e)) then return end
    Group.AddCard(tg,c)
    if e:GetLabel()==0 then    	
        Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    else
	    local gx=Duel.GetMatchingGroup(c49811247.lgfilter4,tp,LOCATION_MZONE,0,nil)
	    if gx:GetCount()==0 then return end
	    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(49811247,5))
	    local tc=gx:Select(tp,1,1,nil):GetFirst()
	    if not tc:IsImmuneToEffect(e) then
		    Duel.Overlay(tc,tg)
		end
    end
end   