--时序的命数 莫伊拉
function c11771295.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c11771295.filter0,c11771295.filter00,2,true)
    -- 不可响应
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c11771295.chainop)
	c:RegisterEffect(e1)
    -- 战吼特招
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11771295,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11771295)
	e2:SetCondition(c11771295.con2)
	e2:SetTarget(c11771295.tg2)
	e2:SetOperation(c11771295.op2)
	c:RegisterEffect(e2)
    -- 效果篡改
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(11771295,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,11771295+100)
    e3:SetCondition(c11771295.con3)
    e3:SetTarget(c11771295.tg3)
    e3:SetOperation(c11771295.op3)
    c:RegisterEffect(e3)
end
-- fusion material
function c11771295.filter0(c,fc,sumtype,tp)
    return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
function c11771295.filter00(c)
    return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 1
function c11771295.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) then
		Duel.SetChainLimit(c11771295.chainlm)
	end
end
function c11771295.chainlm(e,rp,tp)
	return tp==rp
end
-- 2
function c11771295.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c11771295.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11771295.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11771295.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11771295.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11771295.filter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 3
function c11771295.con3(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
end
function c11771295.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c11771295.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c11771295.op33)
end
function c11771295.op33(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif d==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil,POS_FACEDOWN)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif d==3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
	elseif d==4 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif d==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,POS_FACEDOWN)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif d==6 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
	end
end
