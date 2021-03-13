--亡语魔道具 强欲之魔剑
function c99988026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,99988026+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99988026.target)
	e1:SetOperation(c99988026.operation)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_CONTROL)
	e2:SetValue(c99988026.ctval)
	c:RegisterEffect(e2)
	--damage 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99988026,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c99988026.eacon)
	e3:SetTarget(c99988026.eatg)
	e3:SetOperation(c99988026.eaop)
	c:RegisterEffect(e3)
	--Indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)	
	--damage 2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c99988026.refcon)
	c:RegisterEffect(e5)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c99988026.eqlimit)
	c:RegisterEffect(e6)		
	end
function c99988026.eqlimit(e,c)
	return not c:IsSetCard(0x20df)
end
function c99988026.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x20df) and c:IsControlerCanBeChanged()
end
function c99988026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99988026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99988026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99988026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99988026.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c99988026.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c99988026.eacon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetBattledGroupCount()>0
end
function c99988026.eatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetEquipTarget()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c99988026.eaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()	
	if tc and tc:IsFaceup() and  tc:IsLocation(LOCATION_MZONE) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	local dam=tc:GetBaseAttack()
	 local p=tc:GetOwner()
		if dam>0 then Duel.Damage(p,dam,REASON_EFFECT) end
	end
end
function c99988026.refcon(e)
	local c = e:GetHandler()
	local owp = c:GetOwner()
	local ec = c:GetEquipTarget()
	if not ec:IsRelateToBattle() then return false end
	if Duel.GetBattleDamage(owp)>0 and owp ~= ec:GetOwner() then 
		return true 
	else 
		return false
	end
end
