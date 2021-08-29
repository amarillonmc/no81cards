--方舟骑士·影匿之尾 狮蝎
function c82567846.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c82567846.atkcon)
	e3:SetOperation(c82567846.operation)
	c:RegisterEffect(e3)
	--xyzlv
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_XYZ_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c82567846.xyzlv)
	e4:SetLabel(3)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabel(5)
	c:RegisterEffect(e5)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567846,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetProperty(EFFECT_CANNOT_DISABLE)
	e6:SetTarget(c82567846.destg)
	e6:SetOperation(c82567846.desop)
	c:RegisterEffect(e6)
end
function c82567846.atkcon(e)
	return  Duel.GetAttackTarget()~=0 and Duel.GetAttacker()==e:GetHandler() 
	and Duel.GetAttackTarget():GetAttack() >  Duel.GetAttacker():GetAttack()
end

function c82567846.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if c:GetAttack()<d:GetAttack() and c:IsRelateToEffect(e) and d:IsOnField() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		d:RegisterEffect(e1)
	end   
end
function c82567846.xyzlv(e,c,rc)
	if rc:IsSetCard(0x825) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end
function c82567846.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c82567846.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end