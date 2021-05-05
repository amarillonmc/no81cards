--武装升级
function c40008628.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008628)
	e1:SetCost(c40008628.spcost)
	e1:SetTarget(c40008628.target)
	e1:SetOperation(c40008628.operation)
	c:RegisterEffect(e1) 
	--remove overlay replace
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008628,0))
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c40008628.rcon)
	e6:SetOperation(c40008628.rop)
	c:RegisterEffect(e6)   
end
function c40008628.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c40008628.cfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c40008628.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalRank())
end
function c40008628.spfilter(c,e,tp,rk)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:GetOriginalRank()==rk
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40008628.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c40008628.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c40008628.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008628.spfilter(chkc,e,tp) end
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40008628.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40008628.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,gc:GetOriginalRank())
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--Atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(600)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(tc)
		c:RegisterEffect(e2)
		--race
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_EARTH)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(tc)
		c:RegisterEffect(e3)
		--rank
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_CHANGE_RANK)
		e4:SetValue(10)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetLabelObject(tc)
		c:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c40008628.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ)
		and ep==e:GetOwnerPlayer() and e:GetHandler():GetEquipTarget()==re:GetHandler() and re:GetHandler():GetOverlayCount()>=ev-1
end
function c40008628.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end