--永生的灵魂 查拉图斯特拉(注：狸子DIY)
function c77723330.initial_effect(c)
	c:SetUniqueOnField(1,0,77723330) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,77723330)
	e1:SetCondition(c77723330.condition)
	e1:SetTarget(c77723330.target)
	e1:SetOperation(c77723330.operation)
	c:RegisterEffect(e1)
end
function c77723330.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY)
end
function c77723330.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c77723330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77723330.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c77723330.filter,tp,LOCATION_MZONE,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		if ct>0 and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(77723330,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*200)
			Duel.Damage(tp,500,REASON_EFFECT)
		end
	end
end
