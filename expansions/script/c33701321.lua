--虚拟主播 本间向日葵 SP
function c33701321.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c33701321.eqop)
	c:RegisterEffect(e1)
	--sd
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c33701321.sdop)
	c:RegisterEffect(e1)   
end
function c33701321.sdfil(c,e,tp)
	return e:GetHandler():GetEquipGroup():IsContains(c) and c:GetColumnGroupCount()~=0
end
function c33701321.seqfil(c,qg)
	return qg:IsContains(c)
end
function c33701321.sdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c33701321.sdfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp):GetFirst()
	local qg=tc:GetColumnGroup()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SendtoGrave(qg,REASON_EFFECT)
end
function c33701321.eqfil(c)
	return c:IsType(TYPE_EQUIP+TYPE_MONSTER) and not c:IsForbidden()
end
function c33701321.eqop(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c33701321.eqfil,tp,LOCATION_DECK,0,1,nil)	or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local tc=Duel.SelectMatchingCard(tp,c33701321.eqfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,tp,LOCATION_DECK)
	if not Duel.Equip(tp,tc,c) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c33701321.eqlimit)
	tc:RegisterEffect(e1)
		local lv=tc:GetLevel()
		if lv>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(lv*400)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
		end
	end
end
function c33701321.eqlimit(e,c)
	return e:GetOwner()==c
end




