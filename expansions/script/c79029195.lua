--罗德岛·近卫干员-炎客·刃鬼
function c79029195.initial_effect(c)
	c:EnableReviveLimit()
	--cannot lose (damage)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c79029195.surcon1)
	e1:SetOperation(c79029195.surop1)
	c:RegisterEffect(e1)
	--lp check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c79029195.surop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c79029195.surop2)
	c:RegisterEffect(e3)  
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCondition(c79029195.scon)
	e4:SetOperation(c79029195.spop)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c79029195.scon1)
	e4:SetOperation(c79029195.spop1)
	c:RegisterEffect(e4)
	--lose
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c79029195.lose)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e7)
	--cannot target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
end
function c79029195.surcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetLP(tp)<=0
end
function c79029195.surop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,1)
end
function c79029195.surop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLP(tp)<=0 and not c:IsStatus(STATUS_DISABLED) then
		Duel.SetLP(tp,1)
	end
	if Duel.GetLP(tp)==1 and c:IsStatus(STATUS_DISABLED) then
		Duel.SetLP(tp,0)
	end
end
function c79029195.scon(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)>=Duel.GetLP(tp)
end
function c79029195.spop(e,tp,eg,ep,ev,re,r,rp,val)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c79029195.scon1(e,tp,eg,ep,ev,re,r,rp)
   local at=Duel.GetAttacker()
   return at:GetControler()~=tp and at:IsOnField() and at:GetAttack()>=Duel.GetLP(tp) and Duel.GetAttackTarget()==nil
end
function c79029195.spop1(e,tp,eg,ep,ev,re,r,rp,val)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c79029195.lose(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,0x4)
end














