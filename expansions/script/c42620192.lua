--直播☆双子 麻烦制造机
local cm,m=GetID()

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
    --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(0x04)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
    e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m+1)
    e2:SetCondition(cm.srcon)
    e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1151)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckLPCost(tp,1100) end
	Duel.PayLPCost(tp,1100)
end

function cm.tgfilter(c,e,tp)
	return ((c:IsSetCard(0x1151) and c:IsLocation(0x02)) or (c:IsSetCard(0x2151) and c:IsLocation(0x10))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.tglgfilter(c,mg)
    return c:IsRace(RACE_FIEND) and c:IsLinkSummonable(mg)
end

function cm.tgtfilter(g,tp)
    return g:GetClassCount(Card.GetLocation)==#g and #g<=Duel.GetLocationCount(tp,0x04) and Duel.IsExistingMatchingCard(cm.tglgfilter,tp,0x40,0,1,nil,g:__add(Duel.GetFieldGroup(tp,0x04,0))) and (#g==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0x12,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(cm.tgtfilter,1,2,tp) and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g+1,tp,0x52)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0x12,0,nil,e,tp)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    g=g:SelectSubGroup(tp,cm.tgtfilter,false,1,2,tp)
        if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
            local og=Duel.GetOperatedGroup()
	        Duel.AdjustAll()
	        if og:FilterCount(Card.IsLocation,nil,0x04)<#g then return false end
            local tg=Duel.GetMatchingGroup(cm.tglgfilter,tp,0x40,0,nil)
            if #tg>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                tg=tg:Select(tp,1,1,nil)
                local e2=Effect.CreateEffect(e:GetHandler())
                e2:SetType(EFFECT_TYPE_FIELD)
                e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
                e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
                e2:SetTarget(cm.rmtarget)
                e2:SetValue(LOCATION_DECKSHF)
                Duel.RegisterEffect(e2,tp)
                local tc=tg:GetFirst()
                local e3=Effect.CreateEffect(e:GetHandler())
                e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
                e3:SetCode(EVENT_SPSUMMON_SUCCESS)
                e3:SetLabelObject(e2)
                e3:SetOperation(cm.op)
                tc:RegisterEffect(e3)
                Duel.LinkSummon(tp,tc,Duel.GetFieldGroup(tp,0x04,0))
            end
        end
    end
end

function cm.op(e)
    e:GetLabelObject():Reset()
    e:Reset()
end

function cm.rmtarget(e,c)
	return c:GetReason()==REASON_LINK+REASON_MATERIAL
end

function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsPreviousControler(tp)
end

function cm.srfilter(c)
	return c:IsSetCard(0x1151,0x2151) and c:IsAbleToHand()
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,0x10,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,0x10,0,1,1,nil)
	if #g>0 then
        Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        if g:GetFirst():IsLocation(0x02) then
            Duel.ConfirmCards(1-tp,g)
        end
	end
end