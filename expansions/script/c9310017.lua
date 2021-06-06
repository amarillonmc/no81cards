--虚毒概念 单调假说
function c9310017.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c9310017.ffilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c9310017.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	--no xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9310017.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--nontuner
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9310017,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,9310017)
	e5:SetTarget(c9310017.cttg)
	e5:SetOperation(c9310017.ctop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9310017,0))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,9311017)
	e6:SetTarget(c9310017.postg)
	e6:SetOperation(c9310017.operation)
	c:RegisterEffect(e6)
end
function c9310017.ffilter(c)
	return c:IsFusionSetCard(0x144b,0x3f91)
end
function c9310017.value(e,c)
	local p=e:GetHandler():GetEquipTarget():GetControler()
	return Duel.GetCounter(p,1,0,0x144b)*300
end
function c9310017.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function c9310017.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x144b,2)
end
function c9310017.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9310017.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function c9310017.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,c9310017.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		tc:AddCounter(0x144b,2)
	end
end
function c9310017.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local op=2
	e:SetCategory(0)
	if Duel.GetFlagEffect(tp,9310017)==0 and (b1 or b2) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(9310017,1),aux.Stringid(9310017,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(9310017,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9310017,2))+1
		end
		if op==0 then
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
		else
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
			e:SetCategory(CATEGORY_EQUIP)
			Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
		end
		Duel.RegisterFlagEffect(tp,9310017,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end
function c9310017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==2 or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not tc:IsCanChangePosition() then return end
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			c:RegisterEffect(e1)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsFaceup() then return end
		Duel.Equip(tp,c,tc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(c9310017.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c9310017.eqlimit(e,c)
	return c==e:GetLabelObject()
end