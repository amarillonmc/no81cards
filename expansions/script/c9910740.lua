--远古造物 原杉藻
dofile("expansions/script/c9910700.lua")
function c9910740.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xc950),2)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910740)
	e1:SetTarget(c9910740.sptg)
	e1:SetOperation(c9910740.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c9910740.tgcon)
	e2:SetTarget(c9910740.tgtg)
	e2:SetOperation(c9910740.tgop)
	c:RegisterEffect(e2)
end
function c9910740.spfilter(c,e,tp)
	local a=c:GetAttack()
	local b=c:GetDefense()
	if b>a then a=b end
	return c:IsSetCard(0xc950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and a>0 and Duel.IsExistingMatchingCard(c9910740.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,a)
end
function c9910740.atkfilter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c9910740.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910740.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910740.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910740.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910740.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local a=tc:GetAttack()
	local b=tc:GetDefense()
	if b>a then a=b end
	if a==0 or not Duel.IsExistingMatchingCard(c9910740.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,a) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c9910740.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,a)
	Duel.HintSelection(g)
	local sc=g:GetFirst()
	if sc and not sc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-a)
		sc:RegisterEffect(e1)
		if not sc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c9910740.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910740.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9910740.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9910740.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910740.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9910740.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c9910740.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
