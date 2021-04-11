--替身之箭-试炼之箭
function c9300300.initial_effect(c)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9300300+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9300300.target)
	e1:SetOperation(c9300300.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(100)
	c:RegisterEffect(e3)
end
function c9300300.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x1f99)
end
function c9300300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9300300.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9300300.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9300300.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9300300.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsSetCard(0x1f99) then
		Duel.Equip(tp,c,tc)
		local c1,c2=Duel.TossCoin(tp,2)
		if c1+c2==2 then
			Duel.GetControl(tc,tp)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DUAL_STATUS)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetDescription(aux.Stringid(9300300,1))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_SETCODE)
			e3:SetValue(0x1f99)
			tc:RegisterEffect(e3)
		else  
			Duel.Destroy(tc,REASON_EFFECT)  
		end
	end
end
