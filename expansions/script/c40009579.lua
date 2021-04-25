--天轮圣龙 涅槃
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009579)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--tofield
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.tfcost)
	e1:SetTarget(cm.tftg)
	e1:SetOperation(cm.tfop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.acon)
	e2:SetOperation(cm.aop)
	c:RegisterEffect(e2)
end
function cm.acon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(tp)
end
function cm.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f1b) and c:GetSummonType() == SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(cm.afilter,tp,LOCATION_MZONE,0,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() then g:AddCard(c) end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.cfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tffilter1(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tffilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tffilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.tffilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and c:IsRelateToEffect(e) and c:IsFaceup() then
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter1)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter1)
		tc:RegisterEffect(e1)
	end
end
function cm.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end