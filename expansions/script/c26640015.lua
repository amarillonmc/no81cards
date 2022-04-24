--颜彩-守望的银河
local m=26640015
local cm=_G["c"..m]
function c26640015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,26640015)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,26640015)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.chfilter(c)
	return  c:IsAbleToRemoveAsCost() 
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.chfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.chfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe51)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        local hg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
        if hg:GetClassCount(Card.GetCode)>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,0))then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
	end
end
----1效果
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xe51)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
        local hg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil)
        if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and 
        hg:GetClassCount(Card.GetCode)>=5 and hg:GetClassCount(Card.GetCode)>=2 and Duel.SelectYesNo(tp,aux.Stringid(m,1))then
            local sg1=hg:Select(tp,1,1,nil)
            hg:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg2=hg:Select(tp,1,1,nil)
            hg:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
            sg1:Merge(sg2)
            local fid=e:GetHandler():GetFieldID()
            local tc=sg1:GetFirst()
            while tc do
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                tc:RegisterFlagEffect(26640015,RESET_EVENT+0x1fe0000,0,1,fid)
                tc=sg1:GetNext()
            end
             Duel.SpecialSummonComplete()
             local e1=Effect.CreateEffect(c)
             e1:SetType(EFFECT_TYPE_FIELD)
             e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
             e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
             e1:SetTargetRange(1,0)
             e1:SetTarget(cm.splimit)
             e1:SetReset(RESET_PHASE+PHASE_END)
             Duel.RegisterEffect(e1,tp)
        end
	end
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xe51) and c:IsLocation(LOCATION_EXTRA)
end
---2效果