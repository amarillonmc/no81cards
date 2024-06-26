--方舟骑士-重岳
c29002023.named_with_Arknight=1
function c29002023.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,12,c29002023.ovfilter,aux.Stringid(29002022,0),12,c29002023.xyzop)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c29002023.op0)
	c:RegisterEffect(e0)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetOperation(c29002023.op10)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_ATTACK_ANNOUNCE)
	e11:SetOperation(c29002023.op11)
	c:RegisterEffect(e11)
	--double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
	e1:SetCondition(c29002023.damcon)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	--Double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c29002023.atkop)
	c:RegisterEffect(e4)
	if not c29002023.global_check then
		c29002023.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c29002023.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c29002023.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,29002023,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c29002023.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(29002023,0))
end
function c29002023.op10(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(29002023,1))
end
function c29002023.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(29002023,2))
	Duel.Hint(24,0,aux.Stringid(29002023,3))
end
function c29002023.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c29002023.ovfilter(c)
	local tp=c:GetControler()
	local x=Duel.GetFlagEffect(0,29002023)
	return c:IsFaceup() and x>=12 and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c29002023.xyzop(e,tp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002023.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
		if a:IsRelateToBattle() then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_BATTLE_ATTACK)
		e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e4:SetValue(a:GetBaseAttack())
		a:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_BATTLE_DEFENSE)
		e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e5:SetValue(a:GetBaseDefense())
		a:RegisterEffect(e5,true)
		end
		if d and d:IsRelateToBattle() then
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SET_BATTLE_ATTACK)
		e6:SetValue(d:GetBaseAttack())
		e6:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e6,true)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_SET_BATTLE_DEFENSE)
		e7:SetValue(d:GetBaseDefense())
		e7:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e7,true)
		Duel.Hint(24,tp,aux.Stringid(29002023,4))
		end
end