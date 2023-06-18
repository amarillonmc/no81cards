--舞动着的露珠般生命之绯红
local m=40011134
local cm=_G["c"..m]
cm.named_with_FoxArt=1
function cm.Tamayura(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Tamayura
end
function cm.Ririmi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ririmi
end
function cm.Rarami(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Rarami
end

function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

function cm.conafilter(c)
    return c:IsFaceup() and cm.Tamayura(c)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.conafilter,tp,0x04,0,1,nil)
end

function cm.costafilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costafilter,tp,0x40,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costafilter,tp,0x40,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function cm.tgafilter(c,e,tp)
    return c:IsType(TYPE_PENDULUM) and (cm.Ririmi(c) or cm.Rarami(c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(aux.TRUE,tp,0x0c,0x0c,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tgafilter,tp,0x10,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0
    if chkc then return chkc:IsLocation(0x0c) and chkc:IsCanBeEffectTarget(e) end
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        Duel.SelectTarget(tp,aux.TRUE,tp,0x0c,0x0c,1,1,nil)
        e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,Duel.GetFieldGroup(tp,0x0c,0x0c),2,nil,nil)
	else
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x10)
	end
end

function cm.tgsfilterg3(c)
    return cm.Ririmi(c) and cm.Rarami(c)
end

function cm.opsfilter(g)
    local g1=g:Filter(cm.Ririmi,nil)
    local g2=g:Filter(cm.Rarami,nil)
    local g3=g:Filter(cm.tgsfilterg3,nil)
    return (#g1<=1 and #g2<=1) or #g3~=0
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToChain() and Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.GetFieldGroupCount(tp,0x0c,0x0c)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x0c,0x0c,1,1,nil)
            if g:GetCount()>0 then
                Duel.HintSelection(g)
                Duel.SendtoGrave(g,REASON_EFFECT)
            end
        end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(cm.tgafilter,tp,0x10,0,nil,e,tp)
        local ct=Duel.GetLocationCount(tp,0x04)
        if #g>0 and ct>0 then
            if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            g=g:SelectSubGroup(tp,cm.opsfilter,false,1,math.min(2,ct))
            if #g>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
	end
end