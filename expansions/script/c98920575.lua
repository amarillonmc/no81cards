--饥仇毒 致死剂量龙
function c98920575.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c98920575.ffilter,3,true)
	aux.EnablePendulumAttribute(c,false)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c98920575.atkval1)
	c:RegisterEffect(e1)
	 --disable all
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920575,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c98920575.target0)
	e5:SetOperation(c98920575.operation0)
	c:RegisterEffect(e5)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c98920575.operation)
	c:RegisterEffect(e2)
	local e9=e2:Clone()
	e9:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e9)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920575,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c98920575.target)
	e1:SetOperation(c98920575.operation2)
	c:RegisterEffect(e1)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920575,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c98920575.pencon)
	e6:SetTarget(c98920575.pentg)
	e6:SetOperation(c98920575.penop)
	c:RegisterEffect(e6)
	 --atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c98920575.atkval2)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920575,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98920575)
	e1:SetCost(c98920575.spcost)
	e1:SetTarget(c98920575.sptg)
	e1:SetOperation(c98920575.spop)
	c:RegisterEffect(e1)
end
function c98920575.atkval1(e,c)
	return Duel.GetCounter(0,1,1,0xad9)*100
end
function c98920575.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:GetAttack()>0 end
end
function c98920575.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local ct=Duel.GetCounter(0,1,1,0xad9)
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-ct*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e1)
	end
end
function c98920575.atkval2(e,c)
	return Duel.GetCounter(0,1,1,0xad9)*100
end
function c98920575.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_COUNTER_PERMIT+0xad9)
		e1:SetValue(e:GetHandler():GetLocation())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:AddCounter(0xad9,1,REASON_EFFECT)
		tc=g:GetNext()
	end
end
function c98920575.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c98920575.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c98920575.operation0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c98920575.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c98920575.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c98920575.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c98920575.rfilter(c)
	return c:IsAbleToGraveAsCost() and c:GetCounter(0xad9)>0
end
function c98920575.fselect(g,tp)
	return g:GetSum(Card.GetCounter,0xad9)==10 and aux.mzctcheck(g,tp)
end
function c98920575.gcheck(g)
	return g:GetSum(Card.GetCounter,0xad9)<=10
end
function c98920575.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920575.rfilter,tp,LOCATION_MZONE,0,nil)
	aux.GCheckAdditional=c98920575.gcheck
	if chk==0 then
		local res=g:CheckSubGroup(c98920575.fselect,1,g:GetCount(),tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c98920575.fselect,false,1,g:GetCount(),tp)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(rg,REASON_COST)
end
function c98920575.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920575.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end