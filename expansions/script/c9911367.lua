--雪狱之罪境
function c9911367.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9911367.immtg)
	e2:SetValue(c9911367.immval)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911367,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(2)
	e3:SetCost(c9911367.sumcost)
	e3:SetTarget(c9911367.sumtg)
	e3:SetOperation(c9911367.sumop)
	c:RegisterEffect(e3)
	--tohand or remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911367,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,9911367)
	e4:SetCondition(c9911367.secon)
	e4:SetTarget(c9911367.setg)
	e4:SetOperation(c9911367.seop)
	c:RegisterEffect(e4)
	if not c9911367.global_check then
		c9911367.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c9911367.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911367.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsPreviousLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_SPSUMMON) then
			tc:RegisterFlagEffect(9911367,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c9911367.immtg(e,c)
	return c:GetFlagEffect(9911367)~=0
end
function c9911367.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9911367.cffilter(c)
	return not c:IsPublic()
end
function c9911367.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911367.cffilter,tp,0,LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:RandomSelect(tp,1):GetFirst()
	if tc then
		tc:RegisterFlagEffect(9911368,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c9911367.sumfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonable(true,nil)
end
function c9911367.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911367.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9911367.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911367.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c9911367.secon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsPublic,tp,0,LOCATION_HAND,2,nil)
end
function c9911367.synfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9911367.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsSetCard(0xc956) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,0,2,nil,0xc956) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,2,2,nil,0xc956)
	local opt=0
	if g:FilterCount(Card.IsAbleToRemove,nil)~=#g
		or not Duel.IsExistingMatchingCard(c9911367.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(9911367,2))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(9911367,2),aux.Stringid(9911367,3))
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	end
end
function c9911367.seop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	if opt==0 then
		local fid=c:GetFieldID()
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(9911369,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c9911367.thcon)
		e1:SetOperation(c9911367.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c9911367.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc then
				sc:SetMaterial(nil)
				if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
					sc:CompleteProcedure()
				end
			end
		end
	end
end
function c9911367.thfilter(c,fid)
	return c:GetFlagEffectLabel(9911369)==fid and c:IsAbleToHand()
end
function c9911367.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(aux.NecroValleyFilter(c9911367.thfilter),1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9911367.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(aux.NecroValleyFilter(c9911367.thfilter),nil,e:GetLabel())
	g:DeleteGroup()
	if #sg>0 then
		Duel.Hint(HINT_CARD,0,9911367)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
