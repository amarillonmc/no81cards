--fate·花之魔术师
function c9950495.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950495,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950495.con)
	e1:SetTarget(c9950495.rectg)
	e1:SetOperation(c9950495.recop)
	c:RegisterEffect(e1)
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(9950495,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9950495.cost)
	e1:SetTarget(c9950495.target)
	e1:SetOperation(c9950495.operation)
	c:RegisterEffect(e1)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950495.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950495.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950495,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950495,1))
end
function c9950495.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9950495.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and not c:IsCode(9950495)
end
function c9950495.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950495.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9950495.recfilter,tp,LOCATION_MZONE,0,nil)
	local rec=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,rec)
end
function c9950495.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950495.recfilter,tp,LOCATION_MZONE,0,nil)
	local rec=g:GetSum(Card.GetAttack)
	Duel.Recover(tp,rec,REASON_EFFECT)
end
function c9950495.filter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9950495.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,8000) end
	Duel.PayLPCost(tp,8000)
end
function c9950495.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950495.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950495.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950495.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950495,2))
end