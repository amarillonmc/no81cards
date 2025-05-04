--梦化现实，现实化梦
function c75075622.initial_effect(c)
    -- 发动场地魔法
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075622,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75075622)
	e1:SetCost(c75075622.cost1)
	e1:SetTarget(c75075622.tg1)
	e1:SetOperation(c75075622.op1)
	c:RegisterEffect(e1)
	-- 特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075622,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75075623)
	e2:SetCost(c75075622.cost2)
	e2:SetTarget(c75075622.tg2)
	e2:SetOperation(c75075622.op2)
	c:RegisterEffect(e2)
end
-- 1
function c75075622.filter1(c,ft,tp)
	return c:IsSetCard(0x5754)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c75075622.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c75075622.filter1,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c75075622.filter1,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c75075622.filter11(c,tp)
	return c:IsSetCard(0x5754) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c75075622.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075622.filter11,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c75075622.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75075622.filter11),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
    if tc then
        local field=tc:IsType(TYPE_FIELD)
        if field then
            local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
            if fc then
                Duel.SendtoGrave(fc,REASON_RULE)
                Duel.BreakEffect()
            end
            Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
        local te=tc:GetActivateEffect()
        te:UseCountLimit(tp,1,true)
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        if field then
            Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
        end
    end
    if Duel.SelectYesNo(tp,aux.Stringid(75075622,2)) then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.GetMatchingGroup(c75075622.filter111,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
        if #g>0 then
            local sg=Duel.SelectMatchingCard(tp,c75075622.filter111,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
            if #sg>0 then
                Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end
function c75075622.filter111(c,e,tp)
    return c:IsSetCard(0x5754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- 2
function c75075622.filter2(c,tp)
	return c:IsCode(75080003) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c75075622.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75075622.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75075622.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75075622.filter22(c,e,tp)
	return c:IsCode(75080001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75075622.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75075622.filter22,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c75075622.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75075622.filter22),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
