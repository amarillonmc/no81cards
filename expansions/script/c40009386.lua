--宇宙勇机 敌阵突破
function c40009386.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009386,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND+TIMINGS_CHECK_MONSTER)
	--e1:SetCost(c40009386.cost)
	e1:SetTarget(c40009386.target)
	e1:SetOperation(c40009386.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009386,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c40009386.atktg)
	e2:SetOperation(c40009386.atkop)
	c:RegisterEffect(e2) 
end
function c40009386.costfilter(c,matk)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackAbove(matk) and c:IsFaceup() and c:IsSetCard(0x1f1b)
end
--function c40009386.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(100)
	--return true
--end
function c40009386.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local matk=math.min(2000,dc*2000)
	if chk==0 then
		--if e:GetLabel()~=100 then return false end
	   -- e:SetLabel(0)
		return matk>0 and Duel.IsExistingTarget(c40009386.costfilter,tp,LOCATION_MZONE,0,1,nil,matk) --Duel.CheckReleaseGroup(tp,c40009386.costfilter,1,nil,matk)
	end
   -- local g=Duel.SelectReleaseGroup(tp,c40009386.costfilter,1,1,nil,matk)
	local g=Duel.SelectTarget(tp,c40009386.costfilter,tp,LOCATION_MZONE,0,1,1,nil,matk)
	local atk=g:GetFirst():GetAttack()
	--e:SetLabel(atk)
	--Duel.Release(g,REASON_COST)
	local ct=math.floor(atk/2000)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c40009386.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()  then
	--local atk=e:GetLabel()
	local ct=math.floor(atk/2000)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,ct,ct,nil)
		if g:GetCount()~=0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c40009386.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f1b)
end
function c40009386.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009386.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009386.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009386.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40009386.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	end
end