--守护天使 耶胡迪尔
function c40009104.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) end)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009104,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40009104.target)
	e1:SetOperation(c40009104.activate)
	c:RegisterEffect(e1)  
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c40009104.chainop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c40009104.valcheck)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)	 
end
function c40009104.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40009104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40009104.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c40009104.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c40009104.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c40009104.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-ct*800)
end
function c40009104.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c40009104.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and (Duel.GetLP(e:GetHandlerPlayer())<=10000 or Duel.GetLP(1-tp)<=10000)
end
function c40009104.chainop(e,tp,eg,ep,ev,re,r,rp)
	if (e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)) then return 
	Duel.SetChainLimit(c40009104.chlimit)
end
end
function c40009104.chlimit(e,ep,tp)
	return tp==ep
end
function c40009104.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xf27) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
