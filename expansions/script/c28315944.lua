--闪耀的六出花 大崎甜花
function c28315944.initial_effect(c)
	--alstroemeria spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,38315944)
	e1:SetCondition(c28315944.spcon)
	e1:SetTarget(c28315944.sptg)
	e1:SetOperation(c28315944.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28315944)
	e2:SetTarget(c28315944.rectg)
	e2:SetOperation(c28315944.recop)
	c:RegisterEffect(e2)
	c28315944.recover_effect=e2
end
function c28315944.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>8000
end
function c28315944.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28315944.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28315944.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28315944.sfilter(c)
	return c:IsAttackPos() and c:IsCanTurnSet()
end
function c28315944.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c28315944.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315944,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,c28315944.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local c=e:GetHandler()
		if not c:IsRelateToChain() or c:IsFacedown() then return end
		local code=c:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		--e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(c28315944.regcon)
		e1:SetOperation(c28315944.regop)
		e1:SetLabel(code)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28315944.regcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsAttackPos() and at:IsRelateToBattle()
end
function c28315944.gnfilter(c,code)--Good Nignt
	return c:IsCode(code) and c:IsFaceup() and c:IsCanTurnSet()
end
function c28315944.regop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(c28315944.gnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,code)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,28315944)
	Duel.HintSelection(g)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
