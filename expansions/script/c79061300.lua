--病症·幻想人格分裂
function c79061300.initial_effect(c)
	--Equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c79061300.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79061300.target)
	e1:SetOperation(c79061300.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79061300.efilter)
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79061300,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,79061300)
	e3:SetCondition(c79061300.atkcon)
	e3:SetCost(c79061300.xxcost)
	e3:SetTarget(c79061300.xxtg)
	e3:SetOperation(c79061300.xxop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79061300,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79061300)
	e4:SetCondition(c79061300.tgcon)
	e4:SetCost(c79061300.xxcost)
	e4:SetTarget(c79061300.xxtg)
	e4:SetOperation(c79061300.xxop)
	c:RegisterEffect(e4)
end 
c79061300.named_with_XDisease=true 
function c79061300.eqlimit(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c79061300.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c79061300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c79061300.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79061300.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79061300.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79061300.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c79061300.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() then return false end
	return te:IsActivated() 
end
function c79061300.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()  
	local ec=e:GetHandler():GetEquipTarget() 
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and ec and at==ec 
end
function c79061300.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local ec=e:GetHandler():GetEquipTarget()
	if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ec and g and g:IsContains(ec) 
end
function c79061300.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,800) end 
	Duel.PayLPCost(tp,800) 
end 
function c79061300.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==0 then return false end
	e:SetLabel(0) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79061300,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	e:SetLabel(0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c79061300.dkfil(c) 
	return c.named_with_XDisease and not c:IsForbidden() 
end 
function c79061300.xxop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79061300,nil,TYPES_NORMAL_TRAP_MONSTER,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE) 
	if Duel.IsExistingMatchingCard(c79061300.dkfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79061300,0)) then 
	local sc=Duel.SelectMatchingCard(tp,c79061300.dkfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.Equip(tp,sc,c) 
	end 
	end
end 













