--炼金工房主人 莱莎琳·斯托特
function c75011001.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END)
	e1:SetCountLimit(1,75011001)
	e1:SetCondition(c75011001.tgcon)
	e1:SetTarget(c75011001.tgtg)
	e1:SetOperation(c75011001.tgop)
	c:RegisterEffect(e1)
	--summon reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c75011001.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon-other
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1152)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e4:SetCountLimit(1,75011002)
	e4:SetCondition(c75011001.spcon1)
	e4:SetTarget(c75011001.sptg)
	e4:SetOperation(c75011001.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCondition(c75011001.spcon2)
	c:RegisterEffect(e5)
end
function c75011001.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75011001)~=0
end
function c75011001.tgfilter(c)
	return c:IsCode(46130346,5318639) and c:IsAbleToGrave()
end
function c75011001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011001.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75011001.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c75011001.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local e0=Effect.CreateEffect(e:GetHandler())
		if tc:IsCode(46130346) then
			e0:SetDescription(aux.Stringid(75011001,1))
		elseif tc:IsCode(5318639) then
			e0:SetDescription(aux.Stringid(75011001,2))
		end
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(0x20000000+75011001)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e0:SetTargetRange(1,0)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(tc)
		e1:SetCondition(c75011001.arcon)
		e1:SetOperation(c75011001.arop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75011001.arcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and (re:IsActiveType(TYPE_QUICKPLAY) or re:GetActiveType()==TYPE_SPELL)
end
function c75011001.arop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75011001)
	local tc=e:GetLabelObject()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if not te then return end
	Duel.ClearTargetCard()
	--tc:CreateEffectRelation(te)
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 then
		for oc in aux.Next(g) do
			oc:CreateEffectRelation(te)
		end
	end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	--tc:ReleaseEffectRelation(te)
	if g and g:GetCount()>0 then
		for oc in aux.Next(g) do
			oc:ReleaseEffectRelation(te)
		end
	end
	Duel.ResetFlagEffect(tp,75011001)
	e:Reset()
end
function c75011001.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75011001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75011001,3))
end
function c75011001.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011001.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011001.chkfilter,1,nil,tp,rp)
end
function c75011001.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and rp==tp
end
function c75011001.spfilter(c,e,tp)
	return c:IsSetCard(0x75e) and not c:IsCode(75011001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function c75011001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75011001.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c75011001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
	end
end
