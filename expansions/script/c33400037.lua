--D.A.L-时崎狂三-ALTER
function c33400037.initial_effect(c)
	 c:EnableReviveLimit()
	 c:EnableCounterPermit(0x34f)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33400037)
	e1:SetCondition(c33400037.negcon)
	e1:SetCost(c33400037.negcost)
	e1:SetTarget(c33400037.negtg)
	e1:SetOperation(c33400037.negop)
	c:RegisterEffect(e1)
	 --Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400037,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c33400037.Eqop1)
	c:RegisterEffect(e4)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400037,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,33400037+10000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c33400037.descost)
	e3:SetTarget(c33400037.destg)
	e3:SetOperation(c33400037.desop)
	c:RegisterEffect(e3)
end
function c33400037.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x341)
end
function c33400037.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c33400037.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c33400037.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33400037.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33400037.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
	 if Duel.SelectYesNo(tp,aux.Stringid(33400037,0)) then
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400037,3))
	 local tg=Duel.SelectMatchingCard(tp,c33400037.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	 local tc=tg:GetFirst()
	 tc:AddCounter(0x34f,4)
	 end 
end
function c33400037.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,4)
end
function c33400037.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400037.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400037.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400038)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c33400037.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400037.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e6=Effect.CreateEffect(token)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
			e6:SetCode(EVENT_DESTROYED)
			e6:SetRange(LOCATION_SZONE)
			e6:SetCountLimit(1)
			e6:SetCondition(c33400037.condition)
			e6:SetOperation(c33400037.operation3)
			token:RegisterEffect(e6,true)
		   
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400037.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400037.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33400037.cfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==1-tp
end
function c33400037.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400037.cfilter2,1,nil,tp)
end
function c33400037.operation3(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400037,3))
	 local tg=Duel.SelectMatchingCard(tp,c33400037.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	 local tc=tg:GetFirst()
	 tc:AddCounter(0x34f,2)
end

function c33400037.costfilter(c)
	return  c:IsDiscardable() and c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end
function c33400037.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,4,REASON_COST) 
	and Duel.IsExistingMatchingCard(c33400037.costfilter,tp,LOCATION_HAND,0,1,nil)end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400037.desfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x341) or c:IsSetCard(0x340))
end
function c33400037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33400037.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c33400037.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,3,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c33400037.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end