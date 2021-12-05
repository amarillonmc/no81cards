--惧 轮 擒 敌
function c53701021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c53701021.cost)
	e1:SetTarget(c53701021.target)
	e1:SetOperation(c53701021.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c53701021.handcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53701021,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCost(c53701021.descost)
	e3:SetTarget(c53701021.destg)
	e3:SetOperation(c53701021.desop)
	c:RegisterEffect(e3)
end
function c53701021.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c53701021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(c53701021.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c53701021.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function c53701021.filter(c,tp)
	return c:GetSummonPlayer()~=tp and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0 and c:IsLocation(LOCATION_MZONE)
end
function c53701021.spfilter2(c,e,tp)
	return c:IsSetCard(0x3530) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53701021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c53701021.filter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53701021.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c53701021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c53701021.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.SelectMatchingCard(tp,c53701021.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()<=0 and g2:GetCount()<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=g2:GetFirst()
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
			Duel.Equip(tp,c,tc)
			--Add Equip limit
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c53701021.eqlimit)
			c:RegisterEffect(e1)
		end
	elseif c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		c:CancelToGrave(false)
	end
end
function c53701021.eqlimit(e,c)
	return e:GetOwner()==c
end
function c53701021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabelObject(e:GetHandler():GetEquipTarget())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c53701021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsSummonType(SUMMON_TYPE_SPECIAL) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsSummonType,tp,0,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c53701021.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
