--坏掉的玩具
local m=40011126
local cm=_G["c"..m]
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
    e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.condition)
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

function cm.tgafilter(c)
    return (cm.Ririmi(c) or cm.Rarami(c)) and c:IsType(TYPE_PENDULUM)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(cm.tgafilter,tp,0x11,0,nil)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,0x11)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.tgsfilterg3(c)
	return cm.Rarami(c) and cm.Ririmi(c)
end

function cm.opgfilter1(g)
	local g1=g:Filter(cm.Ririmi,nil)
	local g2=g:Filter(cm.Rarami,nil)
	local g3=g:Filter(cm.tgsfilterg3,nil)
	return (#g1<=1 and #g2<=1) or #g3~=0
end

function cm.opgfilterc(c)
    return not c:IsForbidden()
end

function cm.opgfilter2(g)
    return cm.opgfilter1(g) and g:FilterCount(cm.opgfilterc,nil)==#g
end

function cm.opafilter(c)
    return cm.tgafilter(c) and c:IsFaceup()
end

function cm.opgfilter3(g)
	local g1=g:Filter(cm.Ririmi,nil)
	local g2=g:Filter(cm.Rarami,nil)
	return #g1>=1 and #g2>=1
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgafilter,tp,0x11,0,nil)
    local b1=g:CheckSubGroup(cm.opgfilter1,1,2)
    local ct,ck=Duel.GetLocationCount(tp,0x08,2,0x1,0x11),false
    local b2=ct>0 and g:CheckSubGroup(cm.opgfilter2,1,math.min(ct,2))
    if not (b1 or b2) then return false end
    if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
        g=g:SelectSubGroup(tp,cm.opgfilter1,false,1,2)
        if #g>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT) then
            ck=true
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        g=g:SelectSubGroup(tp,cm.opgfilter2,false,1,math.min(ct,2))
        if #g>0 then
            for tc in aux.Next(g) do
                if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
                    ck=true
                end
            end
        end
    end
    if ck then
        Duel.BreakEffect()
        if Duel.GetMatchingGroup(cm.tgafilter,tp,0x40,0,nil):CheckSubGroup(cm.opgfilter3,2,2) and Duel.IsPlayerCanDraw(tp,1) then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end