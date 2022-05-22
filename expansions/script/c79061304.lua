--病症·撒旦之肤
function c79061304.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c79061304.eqlimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79061304.target)
	e1:SetOperation(c79061304.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_CONTROL)
	e2:SetValue(c79061304.ctval)
	c:RegisterEffect(e2)
	
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79061304,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79061304)
	e4:SetCondition(c79061304.atkcon)
	e4:SetCost(c79061304.xxcost)
	e4:SetTarget(c79061304.xxtg)
	e4:SetOperation(c79061304.xxop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79061304,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,79061304)
	e5:SetCondition(c79061304.tgcon)
	e5:SetCost(c79061304.xxcost)
	e5:SetTarget(c79061304.xxtg)
	e5:SetOperation(c79061304.xxop)
	c:RegisterEffect(e5)
end
c79061304.named_with_XDisease=true 
function c79061304.eqlimit(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c79061304.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsControlerCanBeChanged()
end
function c79061304.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79061304.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79061304.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c79061304.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79061304.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
	end
end
function c79061304.ctval(e,c)
	return e:GetHandlerPlayer()
end


function c79061304.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()  
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and ec and at==ec 
end
function c79061304.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local ec=e:GetHandler():GetEquipTarget()
	if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ec and g and g:IsContains(ec) 
end
function c79061304.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end 
	Duel.PayLPCost(tp,800) 
end 
function c79061304.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==0 then return false end
	e:SetLabel(0) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79061304,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c79061304.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Group.CreateGroup()
	local lp=Duel.GetLP(1-tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79061304,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		Duel.SetLP(1-tp,lp-1000)
	end
end