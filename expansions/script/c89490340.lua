--甘露磐龟族·达摩兰哈特
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490273)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc3b),aux.NonTuner(s.mfilter),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Duel.IsMainPhase)
	e1:SetCost(s.immcost)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.synlimit(e,se,sp,st)
end
function s.mnfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToDeckAsCost() and c:IsSetCard(0x198) and Duel.IsExistingMatchingCard(s.mnfilter2,tp,LOCATION_MZONE,0,1,c,c)
end
function s.mnfilter2(c,mc)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToDeckAsCost() and c:IsCode(89490273) and c:GetLevel()+mc:GetLevel()==12
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.mnfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sc=Duel.SelectMatchingCard(tp,s.mnfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,s.mnfilter2,tp,LOCATION_MZONE,0,1,1,sc,sc)
	sg:AddCard(sc)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.SendtoDeck(tg,nil,2,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(aux.indoval)
		tc:RegisterEffect(e3)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
