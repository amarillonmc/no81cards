--AK模组·野战狙击套装
function c82568201.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c82568201.target)
	e1:SetOperation(c82568201.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c82568201.eqlimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,82568201)
	e6:SetTarget(c82568201.destarget)
	e6:SetOperation(c82568201.desop)
	c:RegisterEffect(e6)
end
function c82568201.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c82568201.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568201.desfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c82568201.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local atk=c:GetAttack()
	if e:GetHandler():IsRelateToEffect(e)  then
		local g=Duel.GetMatchingGroup(c82568201.desfilter,tp,0,LOCATION_MZONE,nil,atk)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		local tc=nil
		if g:GetCount()==1 then
			tc=g:GetFirst()
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		local seq=tc:GetSequence()
		local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c82568201.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,tc:GetControler()) end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c82568201.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp)
end
function c82568201.eqlimit(e,c)
	return c:IsCode(82568202,82567801,82567803)
end
function c82568201.filter(c)
	return c:IsFaceup() and c:IsCode(82568202,82567801,82567803)
end
function c82568201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c82568201.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82568201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c82568201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c82568201.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end