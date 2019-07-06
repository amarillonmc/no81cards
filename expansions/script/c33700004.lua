--Protoform 地龙
function c33700004.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33700004.ffilter,4,true)
	  --damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700004,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700004.cost)
	e1:SetTarget(c33700004.target)
	e1:SetOperation(c33700004.operation)
	c:RegisterEffect(e1)
	 --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c33700004.spcon)
	e2:SetOperation(c33700004.spop)
	c:RegisterEffect(e2)
	 --damage2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700004,0))
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c33700004.cost2)
	e3:SetTarget(c33700004.target2)
	e3:SetOperation(c33700004.operation2)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c33700004.pencon)
	e4:SetTarget(c33700004.pentg)
	e4:SetOperation(c33700004.penop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	e5:SetCondition(c33700004.pencon2)
	c:RegisterEffect(e5)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c33700004.descon)
	c:RegisterEffect(e7)
end
function c33700004.ffilter(c)
	return c:IsFusionSetCard(0x6440)   and c:IsType(TYPE_MONSTER)
end
function c33700004.costfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6440)
end
function c33700004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33700004.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c33700004.costfilter,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	local def=g:GetFirst():GetDefense()
	if atk>def then
	e:SetLabel(atk)
	else
	e:SetLabel(def)
	end
	Duel.Release(g,REASON_COST)
end
function c33700004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
	e:SetLabel(0)
end
function c33700004.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c33700004.rmfilter(c,fc,g)
	local tp=fc:GetControler()
	if not (c:IsFusionSetCard(0x6440) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)) then return false end
	g:AddCard(c)
	local res=(g:GetCount()>=4 and Duel.GetLocationCountFromEx(tp,tp,g,fc)>0)
		or Duel.IsExistingMatchingCard(c33700004.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,g,fc,g)
	g:RemoveCard(c)
	return res
end
function c33700004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local c1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local c2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not ((c1 and c1:IsSetCard(0x3440)) or (c2 and c2:IsSetCard(0x3440))) then return false end
	local g=Group.CreateGroup()
	return Duel.IsExistingMatchingCard(c33700004.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,g,c,g)
end
function c33700004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Group.CreateGroup()	
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c33700004.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,g1,e:GetHandler(),g1)
		g1:Merge(g)
	end
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	if g1:FilterCount(Card.IsPreviousLocation,nil,LOCATION_GRAVE)>0 then
		local p=g1:FilterCount(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
		Duel.Damage(tp,p*2000,REASON_EFFECT)
	end
end
function c33700004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c33700004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c33700004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c33700004.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33700004.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>0 end
end
function c33700004.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)<=0 then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c33700004.pencon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33700004.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3440)
end
function c33700004.descon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and not Duel.IsExistingMatchingCard(c33700004.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end