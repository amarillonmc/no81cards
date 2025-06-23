--深渊的呼唤VIII 重获新生
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71200800)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SSET)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.e1f1(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x899) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(cm.e1f1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return #g > 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.e1f2(c,tp)
	return c:IsCode(71200800) and c:IsFaceup() and c:IsControler(tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.e1f1),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g = g:Select(tp,1,1,nil)
	if #g == 0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	g = Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if not (Duel.IsExistingMatchingCard(cm.e1f2,tp,LOCATION_MZONE,0,1,nil) and #g>0
		and Duel.SelectYesNo(tp,1192)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g = g:Select(tp,1,1,nil)
	Duel.BreakEffect()
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x899)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e1)
end
