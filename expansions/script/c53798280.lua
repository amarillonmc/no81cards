local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_FIRE),9,2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.plcon)
	e2:SetTarget(s.pltg)
	e2:SetOperation(s.plop)
	c:RegisterEffect(e2)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		local mct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		local stct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		if stct>mct then
			Duel.NegateEffect(ev)
		end
	end
end
function s.plcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.plfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.plfilter(chkc) end
	if chk==0 then
		if e:IsCostChecked() then
			return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
				and Duel.IsExistingTarget(s.plfilter,tp,0,LOCATION_MZONE,1,nil)
		else return false end
	end
	local rt=Duel.GetTargetCount(s.plfilter,tp,0,LOCATION_MZONE,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.plfilter,tp,0,LOCATION_MZONE,ct,ct,nil)
end
function s.sfilter(c,seq)
	return c:GetSequence()==seq
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #rg>0 then
		for tc in aux.Next(rg) do
			if tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
				local seq=tc:GetSequence()
				local szone_seq=seq
				if seq==5 then szone_seq=1
				elseif seq==6 then szone_seq=3 end
				local zone=1<<szone_seq
				local oc=Duel.GetMatchingGroup(s.sfilter,tp,0,LOCATION_SZONE,nil,szone_seq):GetFirst()
				if oc then
					Duel.Destroy(oc,REASON_RULE)
				end
				if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end