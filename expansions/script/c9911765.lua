--『战列线决战』近江
function c9911765.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911765.mfilter,nil,2,99)
	c:EnableReviveLimit()
	--indes by effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911765,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c9911765.descost)
	e3:SetTarget(c9911765.destg1)
	e3:SetOperation(c9911765.desop)
	c:RegisterEffect(e3)
end
function c9911765.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,8) or c:IsXyzLevel(xyzc,12) or c:IsXyzLevel(xyzc,14)
end
function c9911765.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911765.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
		local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3
		return b1 or b2
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911765,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9911765.descost)
	e1:SetTarget(c9911765.destg2)
	e1:SetOperation(c9911765.desop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9911765.eftg)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c9911765.eftg(e,c)
	return c:IsType(TYPE_XYZ) and c~=e:GetOwner()
end
function c9911765.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
		local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3
		return b1 or b2
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if not c:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c9911765.desop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911765,2)},{b2,aux.Stringid(9911765,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif op==2 then
		local g1=Duel.GetDecktopGroup(tp,3)
		local g2=Duel.GetDecktopGroup(1-tp,3)
		g1:Merge(g2)
		Duel.DisableShuffleCheck()
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
