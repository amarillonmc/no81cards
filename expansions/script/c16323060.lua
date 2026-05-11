--王·破坏死光
function c16323060.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16323060)
	e1:SetCondition(c16323060.condition)
	e1:SetTarget(c16323060.target)
	e1:SetOperation(c16323060.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16323060+1)
	e2:SetCondition(c16323060.condition2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16323060.settg)
	e2:SetOperation(c16323060.setop)
	c:RegisterEffect(e2)
end
function c16323060.cfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x3dcf)
end
function c16323060.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16323060.cfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c16323060.setfilter(c)
	return c:IsSetCard(0x3dcf) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c16323060.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16323060.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function c16323060.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16323060.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c16323060.cfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&0x1>0 and c:IsSetCard(0x3dcf)
end
function c16323060.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x3dcf)
end
function c16323060.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16323060.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c16323060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsAbleToEnterBP()
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,0xc,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,0xc)
end
function c16323060.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	local b1=Duel.IsAbleToEnterBP()
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,0xc,1,nil)
	if b1 then
		if not b2 or Duel.SelectYesNo(tp,aux.Stringid(16323060,1)) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetCondition(c16323060.dcon)
			e1:SetValue(DOUBLE_DAMAGE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			op=1
		end
	end
	b2=Duel.IsExistingMatchingCard(nil,tp,0,0xc,1,nil)
	if b2 and (op==0 or Duel.IsExistingMatchingCard(c16323060.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16323060,2))) then
		if op~=0 then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,0xc,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,0x40)
		end
	end
end
function c16323060.dcon(e)
	return Duel.GetAttackTarget()
end