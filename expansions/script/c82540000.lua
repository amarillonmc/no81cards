--天元突破·红莲螺岩
function c82540000.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,13,5,c82540000.ovfilter,aux.Stringid(82540000,0))
	c:EnableReviveLimit()
	 --spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c82550000.fuslimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--act limit
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82540000,2))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c82540000.target)
	e7:SetOperation(c82540000.operation)
	c:RegisterEffect(e7)
	--atk
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82540000,0))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c82540000.atkcost)
	e8:SetCondition(c82540000.atkcon)
	e8:SetOperation(c82540000.atkop)
	c:RegisterEffect(e8)
	--pierce
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e9)
end
function c82540000.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget() and Duel.GetAttackTarget()~=nil
end
function c82540000.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(82540000)==0 end
	c:RegisterFlagEffect(82540000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c82540000.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetAttackTarget()~=nil then
	local valbase=Duel.GetAttacker():GetAttack()+Duel.GetAttackTarget():GetAttack()
	local val1=valbase*(c:GetOverlayCount()+Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER))
	local val2=val1*(c:GetRank())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(val2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c82540000.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c82540000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	
end
function c82540000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
		 e1:SetValue(c82540000.efilter1)
		elseif e:GetLabel()==1 then
		 e1:SetValue(c82540000.efilter2)
		 else
		 e1:SetValue(c82540000.efilter3)
		 end
		c:RegisterEffect(e1)
end
function c82540000.efilter1(e,te)
	return  te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c82540000.efilter2(e,te)
	return  te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c82540000.efilter3(e,te)
	return  te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c82540000.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=7
end
