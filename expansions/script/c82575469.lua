--FNo.32 未来咬龙 鲨龙兽
function c82575469.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c82575469.sprcon)
	e2:SetOperation(c82575469.sprop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--avoid damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c82575469.atkval)
	c:RegisterEffect(e6)
	--attack twice
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--Negate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,82575469)
	e7:SetCondition(c82575469.discon)
	e7:SetCost(c82575469.discost)
	e7:SetTarget(c82575469.distg)
	e7:SetOperation(c82575469.disop)
	c:RegisterEffect(e7)
end
c82575469.xyz_number=32
function c82575469.tgrfilter(c)
	return c:IsFaceup() and c:IsRankAbove(1) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function c82575469.atkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c82575469.atkval(e,c)
	local nos=Duel.GetMatchingGroup(c82575469.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local tc=nos:GetFirst()
	local rk=0
		while tc do
			local trk=tc:GetRank()
			if trk>0 then rk=rk+trk end
			tc=nos:GetNext()
		end
	return rk*400
end
function c82575469.mnfilter(c,g)
	local rk=c:GetRank()
	return g:IsExists(c82575469.mnfilter2,1,c,rk)
end
function c82575469.mnfilter2(c,rk)
	return rk+c:GetRank()==8
end
function c82575469.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c82575469.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c82575469.sprcon(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c82575469.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c82575469.fselect,2,2,tp,c)
end
function c82575469.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c82575469.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c82575469.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c82575469.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c82575469.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(800) end 
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
		end
	end
function c82575469.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c82575469.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end