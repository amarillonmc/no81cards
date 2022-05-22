--病症·三重律怪血
function c79061305.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c79061305.eqlimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79061305.target)
	e1:SetOperation(c79061305.operation)
	c:RegisterEffect(e1)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c79061305.atk)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	-- 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79061305,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79061305)
	e4:SetCondition(c79061305.atkcon)
	e4:SetCost(c79061305.xxcost)
	e4:SetTarget(c79061305.xxtg)
	e4:SetOperation(c79061305.xxop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79061305,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,79061305)
	e5:SetCondition(c79061305.tgcon)
	e5:SetCost(c79061305.xxcost)
	e5:SetTarget(c79061305.xxtg)
	e5:SetOperation(c79061305.xxop)
	c:RegisterEffect(e5)
	if not c79061305.global_check then
		c79061305.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAINING)
	ge1:SetOperation(c79061305.regop)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_NEGATED)
	ge2:SetOperation(c79061305.regop2)
	Duel.RegisterEffect(ge2,0)
	end
end 
c79061305.named_with_XDisease=true 
function c79061305.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner() 
	local p=c:GetOwner()
		local flag=Duel.GetFlagEffectLabel(p,79061305) 
		if flag then
		Duel.SetFlagEffectLabel(p,79061305,flag+1)
		else
		Duel.RegisterFlagEffect(p,79061305,RESET_PHASE+PHASE_END,0,1,1)
		end
end

function c79061305.regop2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetOwnerPlayer()
		local flag=Duel.GetFlagEffectLabel(p,79061305)
		if flag and flag>0 then
		Duel.SetFlagEffectLabel(p,79061305,flag-1)
		end
end
function c79061305.eqlimit(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c79061305.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c79061305.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c79061305.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79061305.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79061305.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79061305.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c79061305.atk(e,c) 
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffectLabel(tp,79061305)==nil then
	   return 0
	 end
	if Duel.GetFlagEffectLabel(tp,79061305)~=nil then
	return Duel.GetFlagEffectLabel(tp,79061305)*300
	end
end


function c79061305.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()  
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and ec and at==ec 
end
function c79061305.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local ec=e:GetHandler():GetEquipTarget()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ec and g and g:IsContains(ec) 
end
function c79061305.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end 
	Duel.PayLPCost(tp,800) 
end 
function c79061305.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==0 then return false end
	e:SetLabel(0) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79061305,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0) 
	local dam=0 
	if Duel.GetFlagEffectLabel(tp,79061305) then 
	dam=Duel.GetFlagEffectLabel(tp,79061305)*300 
	end 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c79061305.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Group.CreateGroup()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79061305,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end