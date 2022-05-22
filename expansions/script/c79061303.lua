--病症·妄想花园
function c79061303.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c79061303.eqlimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79061303.target)
	e1:SetOperation(c79061303.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79061303.target1)
	e2:SetOperation(c79061303.activate1)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79061303,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79061303)
	e4:SetCondition(c79061303.atkcon)
	e4:SetCost(c79061303.xxcost)
	e4:SetTarget(c79061303.xxtg)
	e4:SetOperation(c79061303.xxop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79061303,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,79061303)
	e5:SetCondition(c79061303.tgcon)
	e5:SetCost(c79061303.xxcost)
	e5:SetTarget(c79061303.xxtg)
	e5:SetOperation(c79061303.xxop)
	c:RegisterEffect(e5)
	
end
c79061303.named_with_XDisease=true 
function c79061303.eqlimit(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c79061303.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end

function c79061303.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c79061303.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79061303.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79061303.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79061303.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end 
function c79061303.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=e:GetHandler():GetEquipTarget() 
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sc:GetSequence()<5) and sc:IsCanBeEffectTarget(e) and  
		Duel.IsPlayerCanSpecialSummonMonster(tp,79061303,0,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c79061303.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79061303,0,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	if tc:IsRelateToEffect(e) then 
	Duel.BreakEffect()
	Duel.Release(tc,REASON_EFFECT)
	end
end


function c79061303.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()  
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and ec and at==ec 
end
function c79061303.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local ec=e:GetHandler():GetEquipTarget()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ec and g and g:IsContains(ec) 
end
function c79061303.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end 
	Duel.PayLPCost(tp,800) 
end 
function c79061303.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==0 then return false end
	e:SetLabel(0) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79061303,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end 
function c79061303.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Group.CreateGroup()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79061303,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	  if Duel.SelectYesNo(tp,aux.Stringid(79061303,0)) then
		Duel.Recover(p,d,REASON_EFFECT)
	   end
   end
end