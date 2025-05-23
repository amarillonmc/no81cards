--拟态武装 规衡
function c67200665.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c67200665.spcon)
	e1:SetTarget(c67200665.sptg)
	e1:SetOperation(c67200665.spop)
	e1:SetCountLimit(1,67200665+EFFECT_COUNT_CODE_OATH)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200665,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67200666)
	e3:SetTarget(c67200665.pltg)
	e3:SetOperation(c67200665.plop)
	c:RegisterEffect(e3)	 
end
function c67200665.spfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsSetCard(0x667b) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER
end
function c67200665.fselect(g,tp)
	return aux.mzctcheck(g,tp)
end
function c67200665.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200665.spfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c67200665.fselect,2,2,tp)
end
function c67200665.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c67200665.spfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c67200665.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200665.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
--
function c67200665.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200665.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200665,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		--indes
		e2:SetDescription(aux.Stringid(67200665,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetRange(LOCATION_SZONE)
		--e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e2:SetCountLimit(1)
		e2:SetCondition(c67200665.negcon)
		e2:SetOperation(c67200665.negop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
	end
end
function c67200665.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x667b) 
end
function c67200665.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200665.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_TRAP)
end
function c67200665.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67200665)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end

