--暴君 尼禄(注：狸子DIY)
function c77723313.initial_effect(c)
   c:SetUniqueOnField(2,1,77723313)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,77723313)
	e1:SetCondition(c77723313.hspcon)
	e1:SetOperation(c77723313.hspop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77723313,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,31332777)
	e2:SetTarget(c77723313.destg)
	e2:SetOperation(c77723313.desop)
	c:RegisterEffect(e2)
	end
function c77723313.spfilter(c,ft)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
		and (ft>0 or c:GetSequence()<5)
end
function c77723313.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c77723313.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c77723313.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77723313.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Destroy(g,REASON_COST)
end
function c77723313.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    if g:GetFirst():IsAttribute(ATTRIBUTE_FIRE) then
		local atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
end
function c77723313.desfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c77723313.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetTextAttack()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsAttribute(ATTRIBUTE_FIRE)
	and Duel.Damage(1-tp,math.ceil(tc:GetBaseAttack()/2),REASON_EFFECT)
	and Duel.SelectYesNo(tp,aux.Stringid(77723313,0)) then
	local g=Duel.SelectMatchingCard(tp,c77723313.desfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
		    Duel.Destroy(g,REASON_EFFECT)			
		end
	end
end