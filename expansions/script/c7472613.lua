--秘异三变体泛发产育
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.negcon)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--destroy replace
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)]]
end
function s.costfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function s.thfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x157) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local tc=g:GetFirst()
		e:SetLabel(tc:GetType()&0x7)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetLabel(0)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()~=0 then
		local type1=e:GetLabel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,type1)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,nil,e,tp)
			if #g>0 and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x157) and c:IsControler(tp) and c:IsOnField()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return --e:GetHandler():GetFlagEffect(id)==0 and 
		re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(s.tfilter,1,nil,tp)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		--e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x157)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function s.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x157)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,0,2,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,0,2,2,nil,e,tp)
		e:SetLabelObject(g)
		g:KeepAlive()
		--local tc=g:GetFirst()
		for tc in aux.Next(g) do
			tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		end
		return true
	end
	return false
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	end
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
