local m=90700008
local cm=_G["c"..m]
cm.name="霜火猛犸"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	c90700008.act=e1
	local e2=e1:Clone()
	e2:SetCondition(cm.actcon)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsPosition(POS_FACEDOWN) and tc:IsLocation(LOCATION_REMOVED) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.actspfilter(c,e,tp)
	return c:IsLevel(3) and c:IsSetCard(0x5ac0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.actserfilter(c)
	return c:IsSetCard(0x5ac0) and c:IsAbleToHand()
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if e:GetLabel()==1 then
		tc=eg:GetFirst()
	else
		tc=e:GetHandler()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	tc:AddCounter(0x5ac0,2)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5ac0)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5ac0)
	end
	if ffcount>=5 then
		local spcon=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.actspfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		local thcon=Duel.IsExistingMatchingCard(cm.actserfilter,tp,LOCATION_DECK,0,1,nil)
		local op=1
		if spcon and thcon then
			op=Duel.SelectOption(tp,aux.Stringid(90700008,0),aux.Stringid(90700008,2),aux.Stringid(90700008,1))
		elseif spcon then
			op=Duel.SelectOption(tp,aux.Stringid(90700008,0),aux.Stringid(90700008,2))
		elseif thcon then
			op=Duel.SelectOption(tp,aux.Stringid(90700008,2),aux.Stringid(90700008,1))+1
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.actspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.actserfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0x5ac0) and tc:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5ac0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.tffilter(c)
	return c:IsSetCard(0x5ac0) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:IsActiveType(TYPE_SPELL) and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			sc:AddCounter(0x5ac0,2)
		end  
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local mc=g:GetFirst()
			Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
			mc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
			mc:RegisterEffect(e2)
			mc:AddCounter(0x5ac0,2)
		end
	end
end