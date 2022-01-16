--机械进化装置
function c9910900.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9910900.target)
	e1:SetOperation(c9910900.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9910900)
	e3:SetCondition(c9910900.spcon)
	e3:SetTarget(c9910900.sptg)
	e3:SetOperation(c9910900.spop)
	c:RegisterEffect(e3)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9910900)
	e1:SetCondition(c9910900.discon)
	e1:SetCost(aux.bfgcost)
	e1:SetOperation(c9910900.disop)
	c:RegisterEffect(e1)
end
function c9910900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9910900.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9910900.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_MATERIAL+REASON_FUSION)
end
function c9910900.spfilter(c,e,tp,race)
	return aux.IsCodeListed(c,9910871) and not c:IsRace(race) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910900.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910900.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRace()) end
	e:SetLabel(ec:GetRace())
end
function c9910900.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local race=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910900.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,race)
	local ec=g:GetFirst()
	local res=false
	if ec and Duel.SpecialSummonStep(ec,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsRelateToEffect(e) and Duel.Equip(tp,c,ec) then
			res=true
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9910900.eqlimit)
			e1:SetLabelObject(ec)
			c:RegisterEffect(e1)
		end
	end
	if Duel.SpecialSummonComplete()==0 or not res then return end
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910900,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9910900.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c9910900.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local res=false
	for i=1,ev-1 do
		local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then res=true end
	end
	return res and re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_MACHINE) and rc:IsSummonLocation(LOCATION_EXTRA)
end
function c9910900.disop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c9910900.negcon)
	e2:SetOperation(c9910900.negop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c9910900.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(tp,9910900)==0 and ep~=tp
end
function c9910900.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910900)
	Duel.RegisterFlagEffect(tp,9910900,RESET_PHASE+PHASE_END,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
	e:Reset()
end
