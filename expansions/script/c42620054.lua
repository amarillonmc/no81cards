--海晶少女 阿玛比埃
local m=42620054
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.spcon)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(0x0c)
	e2:SetCountLimit(1,m+1)
    e2:SetCondition(cm.thcon)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_HAND)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(0x0c)
	e3:SetCountLimit(1,m+2)
    e3:SetCondition(cm.recon)
    e3:SetCost(cm.recost)
    e3:SetTarget(cm.retg)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end

function cm.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(0x08)
end

function cm.tgsfilter(c,e,tp)
	return c:IsSetCard(0x12b) and Duel.GetLocationCount(tp,0x04)>0 and c:IsType(0x01) and (cm.tgsfilter1(c,e,tp) or cm.tgsfilter2(c,tp))
end

function cm.tgsfilter1(c,e,tp)
    return not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.tgsfilter2(c,tp)
    return Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x12b,TYPES_EFFECT_TRAP_MONSTER,0,0,4,RACE_CYBERSE,ATTRIBUTE_WATER) and c:IsAbleToHand()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tgsfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgsfilter,tp,0x10,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgsfilter,tp,0x10,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if cm.tgsfilter1(tc,e,tp) and cm.tgsfilter2(tc,tp) then
        g:AddCard(c)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,nil,nil)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,nil,nil)
        Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x16)
    elseif cm.tgsfilter1(tc,e,tp) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,nil,nil)
        Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x16)
    elseif cm.tgsfilter2(tc,tp) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,nil,nil)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,nil,nil)
    end
end

function cm.opstgfilter(c)
    return c:IsSetCard(0x12b) and c:IsFaceup()
end

function cm.opseqfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and ((not c:IsForbidden()) or c:IsLocation(0x04))
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,0x04)<=0 then return false end
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        if cm.tgsfilter1(tc,e,tp) and ((not (c:IsFaceup() and cm.tgsfilter2(tc,tp))) or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
            Duel.BreakEffect()
            local g=Duel.GetMatchingGroup(cm.opstgfilter,tp,0x04,0,nil)
            local qg=Duel.GetMatchingGroup(cm.opseqfilter,tp,0x16,0,nil)
            if #g>0 and #qg>0 and g:__add(qg):GetCount()>=2 and Duel.GetLocationCount(tp,0x08)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	            local qc=qg:Select(tp,1,1,g:__band(qg):GetCount()<=1 and g:__band(qg) or nil):GetFirst()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
                local gc=g:Select(tp,1,1,qc):GetFirst()
                if not Duel.Equip(tp,qc,gc) then return false end
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetLabelObject(gc)
                e1:SetValue(cm.eqlimit)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                qc:RegisterEffect(e1)
            end
        elseif c:IsFaceup() and cm.tgsfilter2(tc,tp) then
            c:AddMonsterAttribute(TYPE_EFFECT)
            if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) and Duel.SendtoHand(tc,nil,REASON_EFFECT) and tc:IsLocation(0x02) then
                Duel.ConfirmCards(1-tp,tc)
            end
        end
    end
end

function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.contfilter(c,tp)
    return c:IsSetCard(0x12b) and c:IsFaceup() and not c:IsCode(m) and c:IsSummonPlayer(tp)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.contfilter,1,nil,tp)
end

function cm.retfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.retfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.retfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.conrfilter(c,tp)
    return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsLocation(0x02) and c:IsControler(tp) and not c:IsPublic()
end

function cm.recon(e,tp,eg,ep,ev,re,r,rp)
    return eg:FilterCount(cm.conrfilter,nil,tp)==1
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ec=eg:Filter(cm.conrfilter,nil,tp):GetFirst()
	if chk==0 then return ec:GetBaseAttack()>0 and cm.cost(e,tp,eg,ep,ev,re,r,rp,0) end
    cm.cost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.ConfirmCards(1-tp,ec)
    Duel.ShuffleHand(tp)
    e:SetLabel(ec:GetBaseAttack())
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end