--战械人形 AR15
function c29065604.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,29065604)
	e1:SetTarget(c29065604.eqtg)
	e1:SetOperation(c29065604.eqop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c29065604.eftg1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--effect gain synchro
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c29065604.eftg2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c29065604.eftg1(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad)
end
function c29065604.eftg2(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad) and c:IsType(TYPE_SYNCHRO)
end
function c29065604.eqfil(c,tp) 
	return c:IsSetCard(0x87ad) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
end
function c29065604.eqtfil(c)
	return c:IsSetCard(0x7ad)
end
function c29065604.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065604.eqfil,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c29065604.eqtfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065604.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065604.eqfil,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c29065604.eqtfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ec=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Equip(tp,ec,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c29065604.eqlimit)
			ec:RegisterEffect(e1)
	end
end
function c29065604.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
