--魔偶甜点主筵
local cm,m=GetID()

function cm.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0x04,0)>Duel.GetMatchingGroupCount(Card.IsType,tp,0x10,0,nil,TYPE_MONSTER)
end

function cm.tgsfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(77848740)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.GetFlagEffect(tp,m)==0
    local b2=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x01,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 and Duel.GetFlagEffect(tp,m+1)==0
	if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
    e:SetLabel(op)
    if op==1 then
        e:SetCategory(CATEGORY_LVCHANGE|e:GetCategory())
    elseif op==2 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON|e:GetCategory())
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
    end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local op=e:GetLabel()
	if op==1 then
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetTargetRange(0x04,0)
        e1:SetTarget(cm.distarget)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(5)
        Duel.RegisterEffect(e1,tp)
	elseif op==2 then
        Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
        if Duel.GetLocationCount(tp,0x04)==0 then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x01,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(m,2))
            e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_PHASE+PHASE_END)
            e2:SetCountLimit(1)
            e2:SetRange(LOCATION_MZONE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e2:SetOperation(cm.retop)
            tc:RegisterEffect(e2)
		end
    end
end

function cm.distarget(e,c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsSetCard(0x71)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end