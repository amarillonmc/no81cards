--病症·幻梦猎魔
function c79061306.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c79061306.eqlimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79061306.target)
	e1:SetOperation(c79061306.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79061306.descon)
	e2:SetOperation(c79061306.desop)
	c:RegisterEffect(e2)


	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79061306,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79061306)
	e4:SetCondition(c79061306.atkcon)
	e4:SetCost(c79061306.xxcost)
	e4:SetTarget(c79061306.xxtg)
	e4:SetOperation(c79061306.xxop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79061306,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,79061306)
	e5:SetCondition(c79061306.tgcon)
	e5:SetCost(c79061306.xxcost)
	e5:SetTarget(c79061306.xxtg)
	e5:SetOperation(c79061306.xxop)
	c:RegisterEffect(e5)
	if not c79061306.global_check then
		c79061306.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	ge1:SetOperation(c79061306.lpckop)
	Duel.RegisterEffect(ge1,0)
	end
end
c79061306.named_with_XDisease=true 
function c79061306.lpckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetOwner() 
	local xp=c:GetOwner()
	local lp=Duel.GetLP(xp)
	local flag=Duel.GetFlagEffectLabel(xp,79061306)
	if flag then
	Duel.SetFlagEffectLabel(xp,79061306,lp)
	else
	Duel.RegisterFlagEffect(xp,79061306,RESET_PHASE+PHASE_END,0,1,lp)
	end 
end 
function c79061306.eqlimit(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c79061306.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end

function c79061306.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c79061306.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79061306.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79061306.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79061306.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c79061306.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	return bc 
end
function c79061306.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetHandler():GetEquipTarget()
	local ac=rc:GetAttack()
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-ac)
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetLabel(ac) 
	e1:SetOperation(c79061306.lpop)  
	e1:SetReset(RESET_EVENT+EVENT_DAMAGE_STEP_END) 
	Duel.RegisterEffect(e1,tp)
end
function c79061306.lpop(e,tp,eg,ep,ev,re,r,rp) 
	local ac=e:GetLabel()
	Duel.Hint(HINT_CARD,0,79061306) 
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)+ac)
end 
function c79061306.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()  
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and ec and at==ec 
end
function c79061306.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local ec=e:GetHandler():GetEquipTarget()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ec and g and g:IsContains(ec) 
end
function c79061306.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end 
	Duel.PayLPCost(tp,800) 
end 
function c79061306.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==0 then return false end
	e:SetLabel(0) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79061306,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c79061306.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Group.CreateGroup()
	local xlp=Duel.GetFlagEffectLabel(tp,79061306) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79061306,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE) 
		Duel.BreakEffect()
		Duel.SetLP(tp,xlp)
   end
end