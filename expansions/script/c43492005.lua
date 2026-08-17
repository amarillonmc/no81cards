-- 凄陌寒昼·雪生狩影
local s,id,o=GetID()
function s.initial_effect(c)
    --①效果：双方回合，解放自身和另一只本家，选对方1手卡送墓
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.tg1)
    e1:SetOperation(s.op1)
    c:RegisterEffect(e1)

    --②效果：本家仪式怪兽从自己场上离开时，从墓地特召自身
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.con2)
    e2:SetTarget(s.tg2)
    e2:SetOperation(s.op2)
    c:RegisterEffect(e2)
end

function s.releasefilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return (val==nil or val(re,c)~=true) and c:IsSetCard(0x3f15)
end
--①效果cost
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        --自身必须在手卡或怪兽区
        if not s.releasefilter(c,tp) then return false end
        --需要存在另一只可解放的本家
        local g=Duel.GetMatchingGroup(s.releasefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,e,tp)
        return #g>0
    end

    --选择另一只本家解放
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.releasefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,e,tp)
    --合并自身并解放
    g:AddCard(c)
    Duel.Release(g,REASON_COST)
end

--①效果目标检查
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,1-tp,LOCATION_HAND)
end

--①效果处理
function s.op1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if #g==0 then return end
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local sg=g:Select(tp,1,1,nil)
    if #sg>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end

--②效果条件过滤：本家仪式怪兽从自己场上离开
function s.ritualfilter(c,tp)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_RITUAL)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end

--②效果条件
function s.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.ritualfilter,1,nil,tp)
end

--②效果目标
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--②效果处理
function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end