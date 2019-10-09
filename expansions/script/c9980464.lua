--智脑-913B2 Kaixa Pointer
function c9980464.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9980464.target)
	e1:SetOperation(c9980464.activate)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9980464.atlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c9980464.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c9980464.filter(c)
	return c:IsControler(tp) or c:IsAbleToChangeControler()
end
function c9980464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c9980464.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9980464.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9980464,0xbca,0x21,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9980464.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9980464.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,9980464,0xbca,0x21,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9980464.atkval)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3,true)
	Duel.SpecialSummonComplete()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.BreakEffect()
		if not Duel.Equip(tp,tc,c,false) then return end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(c9980464.eqlimit)
		tc:RegisterEffect(e4,true)
		e2:SetLabelObject(tc)
		e3:SetLabelObject(tc)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980464,0)) 
end
function c9980464.atkval(e,c)
	local tc=e:GetLabelObject()
	if not tc or tc:GetEquipTarget()~=c then return 0 end
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	return atk
end
function c9980464.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980464.atlimit(e,c)
	return c~=e:GetHandler()
end
function c9980464.tgtg(e,c)
	return c~=e:GetHandler()
end