--龙猿圣尊-圣精灵形态
function c10888936.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10888936,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10888936.hspcon)
	e2:SetTarget(c10888936.hsptg)
	e2:SetOperation(c10888936.hspop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10888936,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10888936.atktg)
	e3:SetOperation(c10888936.atkop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10888936,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c10888936.kxop)
	c:RegisterEffect(e4)
end
function c10888936.hspfilter(c)
	return c:IsAttackAbove(0) and c:IsType(TYPE_MONSTER)
end
function c10888936.hspcheck(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,1) and Duel.GetMZoneCount(tp,g)>0
end
function c10888936.hspgcheck(g)
	if g:GetSum(Card.GetAttack)<=0 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,1)
end
function c10888936.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c10888936.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10888936.hspfilter,c)
	aux.GCheckAdditional=c10888936.hspgcheck
	local res=g:CheckSubGroup(c10888936.hspcheck,1,#g,tp)
	aux.GCheckAdditional=nil
	return res
end
function c10888936.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10888936.hspfilter,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.GCheckAdditional=c10888936.hspgcheck
	local sg=g:SelectSubGroup(tp,c10888936.hspcheck,true,1,#g,tp)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c10888936.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Release(sg,REASON_COST)
	sg:DeleteGroup()
end
function c10888936.atkfilter(c,e)
	return c:IsFaceup() and c:IsAttackAbove(0) and not c:IsImmuneToEffect(e)
end
function c10888936.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10888936.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e) end
	local g=Duel.GetMatchingGroup(c10888936.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	local atk=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c10888936.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10888936.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if #g>0 then
		local atk=g:GetSum(Card.GetAttack)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local atk2=g:GetSum(Card.GetAttack)
		if atk-atk2>0 then
			Duel.Recover(tp,atk-atk2,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c10888936.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c10888936.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c10888936.kxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(c10888936.efilter)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c10888936.efilter(e,te)
	return Duel.GetOperationInfo(ev,CATEGORY_DISABLE) and te:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end