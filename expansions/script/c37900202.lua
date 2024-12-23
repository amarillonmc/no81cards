--「刀仕祢宜」·朱雀院椿
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(s.aacon)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	e4:SetCondition(s.actcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	--e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id)
	--e5:SetCondition(s.sumcon)
	e5:SetTarget(s.sumtg)
	e5:SetOperation(s.sumop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.descon)
	--e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(s.eqcon1)
	e7:SetOperation(s.eqop1)
	c:RegisterEffect(e7)
	local e8 = e7:Clone()
	e8:SetCondition(s.eqcon2)
	e8:SetOperation(s.eqop2)
	c:RegisterEffect(e8)
end
function s.eqcon2(e,tp)
	
	return Duel.GetFlagEffect(tp,id)>=4
end
function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,37900205)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	--e1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	token:RegisterEffect(e2,true)
	token:CancelToGrave()  
	local c = e:GetHandler()
	if Duel.Equip(tp,token,c,false) then 
		local e3=Effect.CreateEffect(token)
		e3:SetType(EFFECT_TYPE_EQUIP)
		
		
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		--e3:SetCondition(s.immcon)
		e3:SetValue(s.efilter2)
		token:RegisterEffect(e3)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_RECOVER)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		
		e1:SetCondition(s.reccon)
		e1:SetTarget(s.rectg)
		e1:SetOperation(s.recop)
		c:RegisterEffect(e1)
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(Duel.GetBattleDamage(1-tp)+Duel.GetBattleDamage(tp))
	
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,Duel.GetBattleDamage(1-tp)+Duel.GetBattleDamage(tp))
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
	
	
end
function s.eqcon1(e,tp)
	
	return Duel.GetFlagEffect(tp,id)<=3
end
function s.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,37900204)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	--e1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	token:RegisterEffect(e2,true)
	token:CancelToGrave()  
	local c = e:GetHandler()
	if Duel.Equip(tp,token,c,false) then 
		local e3=Effect.CreateEffect(token)
		e3:SetType(EFFECT_TYPE_EQUIP)
		
		
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		--e3:SetCondition(s.immcon)
		e3:SetValue(s.efilter)
		token:RegisterEffect(e3)
		local e2=Effect.CreateEffect(token)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		
		e2:SetValue(s.valcon)
		token:RegisterEffect(e2)
	end
end
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and s.cfilter(c,e:GetHandler()) and Duel.GetFlagEffect(tp,id)>=4
end
function s.cfilter(c,mc)
	return c:GetAttack()<=mc:GetAttack() or c:GetDefense()<=mc:GetAttack()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	if not Duel.SendtoGrave(tc,REASON_RULE) then return end
	d=c:GetAttack()-tc:GetAttack()
	Duel.Damage(1-tp,d,REASON_EFFECT)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetFlagEffect(tp,id)>=3
end
function s.aacon(e,tp)
	
	return Duel.GetFlagEffect(tp,id)>=2
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(id) then
			Duel.RegisterFlagEffect(tp,id,nil,0,1)
		end
		tc=eg:GetNext()
	end
	
	--Duel.RegisterFlagEffect(1-tp,10019,RESET_PHASE+PHASE_END,0,1)
end
function s.atkval(e,c)
	
	return Duel.GetFlagEffect(tp,id)*1500
	
	
end