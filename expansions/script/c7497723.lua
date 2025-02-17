--元素灵剑士·疾风
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--add effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.addcon)
	e3:SetOperation(s.addop)
	c:RegisterEffect(e3)
end
function s.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function s.regfilter(c,attr)
	return c:IsSetCard(0x400d) and bit.band(c:GetOriginalAttribute(),attr)~=0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,61557074)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,61557074)
		fe:UseCountLimit(tp)
	end
	local flag=0
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=bit.bor(flag,0x1) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=bit.bor(flag,0x2) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=bit.bor(flag,0x4) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and e:GetLabelObject():GetLabel()~=0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	--add effect
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e01:SetType(EFFECT_TYPE_FIELD)
	--e01:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e01:SetRange(LOCATION_MZONE)
	e01:SetReset(RESET_EVENT+RESETS_STANDARD)
	--e01:SetTargetRange(1,0)
	if bit.band(flag,0x1)~=0 then
		local e02=e01:Clone()
		e02:SetCode(id+2)
		e02:SetCountLimit(1)
		--e02:SetCountLimit(1,id+2)
		c:RegisterEffect(e02)
		local e1=e0:Clone()
		e1:SetDescription(aux.Stringid(id,1))
		c:RegisterEffect(e1)
	end
	if bit.band(flag,0x2)~=0 then
		local e03=e01:Clone()
		e03:SetCode(id+3)
		e03:SetCountLimit(1)
		--e03:SetCountLimit(1,id+3)
		c:RegisterEffect(e03)
		local e2=e0:Clone()
		e2:SetDescription(aux.Stringid(id,2))
		c:RegisterEffect(e2)
	end
	if bit.band(flag,0x4)~=0 then
		local e04=e01:Clone()
		e04:SetCode(id+4)
		e04:SetCountLimit(1)
		--e04:SetCountLimit(1,id+4)
		c:RegisterEffect(e04)
		local e3=e0:Clone()
		e3:SetDescription(aux.Stringid(id,3))
		c:RegisterEffect(e3)
	end
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	local ec=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x400d) 
	and (ec:IsHasEffect(id+2) or ec:IsHasEffect(id+3) or ec:IsHasEffect(id+4))
	--and (Duel.IsPlayerAffectedByEffect(tp,id+2) or Duel.IsPlayerAffectedByEffect(tp,id+3) or Duel.IsPlayerAffectedByEffect(tp,id+4))
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local ec=e:GetHandler()
	--Duel.HintSelection(Group.FromCards(ec))
	Duel.ChangeChainOperation(ev,
	function(e,tp,eg,ep,ev,re,r,rp)
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		--local te2=Duel.IsPlayerAffectedByEffect(tp,id+2)
		--local te3=Duel.IsPlayerAffectedByEffect(tp,id+3)
		--local te4=Duel.IsPlayerAffectedByEffect(tp,id+4)
		local te2=ec:IsHasEffect(id+2)
		local te3=ec:IsHasEffect(id+3)
		local te4=ec:IsHasEffect(id+4)
		local att=e:GetHandler():GetAttribute()
		if te2 and ec:GetFlagEffect(id+2)<=0 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,att) and Duel.SelectEffectYesNo(tp,ec,aux.Stringid(id,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,att)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			ec:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			te2:UseCountLimit(tp)
		end 
		if te3 and ec:GetFlagEffect(id+3)<=0 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,att) and Duel.SelectEffectYesNo(tp,ec,aux.Stringid(id,6)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,att)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			ec:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			te3:UseCountLimit(tp)
		end 
		if te4 and ec:GetFlagEffect(id+4)<=0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,att) and Duel.SelectEffectYesNo(tp,ec,aux.Stringid(id,7)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,att)
			if #sg>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
			ec:RegisterFlagEffect(id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			te4:UseCountLimit(tp)
		end 
	end)
end
function s.thfilter1(c,att)
	return c:IsSetCard(0x400d) and c:GetAttribute()==att and c:IsAbleToHand()
end
function s.thfilter1(c,att)
	return c:IsSetCard(0x400d) and c:GetAttribute()==att and c:IsAbleToHand()
end
function s.tgfilter(c,att)
	return c:GetAttribute()==att and c:IsAbleToGrave()
end
