--永恒至爱英雄
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e00=Effect.CreateEffect(c)
	e00:SetCategory(CATEGORY_EQUIP)
	e00:SetType(EFFECT_TYPE_ACTIVATE)
	e00:SetCode(EVENT_FREE_CHAIN)
	e00:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e00:SetTarget(s.target)
	e00:SetOperation(s.operation)
	c:RegisterEffect(e00)
	--equip limit
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_EQUIP_LIMIT)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e01:SetValue(s.eqlimit)
	c:RegisterEffect(e01)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--Double Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	e4:SetCondition(s.atkcon)
	c:RegisterEffect(e4)
	--activate field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,11881272)
	e5:SetTarget(s.acttg)
	e5:SetOperation(s.actop)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.con3)
	e6:SetOperation(s.op3)
	c:RegisterEffect(e6)
end
--activate
function s.eqfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsSetCard(0x8)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and s.eqfilter(tc) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--equip limit
function s.eqlimit(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x8)
end
--atk up
function s.atkval(e,c)
	return e:GetHandler():GetEquipTarget():GetBaseDefense()
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
--activate field
function s.actfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11881272,2))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,11881272,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,11881272)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,11881272,RESET_CHAIN,0,1) end
		local b=te:IsActivatable(tp,true,true)
		if b then
			Duel.ResetFlagEffect(tp,11881272)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
--negate
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.GetFlagEffect(tp,id)<1
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,id)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end