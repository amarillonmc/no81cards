--卡俄斯之刻
local s,id=GetID()
s.named_with_Soldier=1

function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020965)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
	s.soldier_field_effect = e3 
end

function s.ckfilter(c)
	return c:IsCode(40020965) and c:IsFaceup() 
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_EXTRA+LOCATION_PZONE,0,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function s.hasmainsz(tp)
	for seq=0,4 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,seq) then return true end
	end
	return false
end

function s.getmainzone(tp)
	for seq=0,4 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,seq) then return 1<<seq end
	end
	return 0
end

function s.szfreefilter(c)
	if c:GetSequence()>=5 then return false end
	return c:IsAbleToRemove() or c:IsAbleToGrave() or c:IsAbleToDeck()
end

function s.safeTempRemove(temp_card)
	if temp_card:IsAbleToRemove() then
		Duel.Remove(temp_card, POS_FACEDOWN, REASON_RULE)
		return "removed"
	elseif temp_card:IsAbleToGrave() then
		Duel.SendtoGrave(temp_card, REASON_RULE)
		return "grave"
	elseif temp_card:IsAbleToDeck() then
		Duel.SendtoDeck(temp_card, nil, SEQ_DECKTOP, REASON_RULE)
		return "deck"
	end
	return nil
end

function s.restoreTempCard(e, tp, temp_card, temp_seq, temp_pos, temp_original_type, temp_current_type, location_type)
	if location_type == "removed" and not temp_card:IsLocation(LOCATION_REMOVED) then return false end
	if location_type == "grave" and not temp_card:IsLocation(LOCATION_GRAVE) then return false end
	if location_type == "deck" and not temp_card:IsLocation(LOCATION_DECK) then return false end
	
	local zone = 1 << temp_seq
	local added_type = temp_current_type & (~temp_original_type)
	local removed_type = temp_original_type & (~temp_current_type)
	
	if removed_type ~= 0 then
		local e_rm = Effect.CreateEffect(e:GetHandler())
		e_rm:SetType(EFFECT_TYPE_SINGLE)
		e_rm:SetCode(EFFECT_REMOVE_TYPE)
		e_rm:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_rm:SetValue(removed_type)
		e_rm:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		temp_card:RegisterEffect(e_rm, true)
	end
	if added_type ~= 0 then
		local e_ad = Effect.CreateEffect(e:GetHandler())
		e_ad:SetType(EFFECT_TYPE_SINGLE)
		e_ad:SetCode(EFFECT_ADD_TYPE)
		e_ad:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_ad:SetValue(added_type)
		e_ad:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		temp_card:RegisterEffect(e_ad, true)
	end
	
	Duel.MoveToField(temp_card, tp, tp, LOCATION_SZONE, temp_pos, true, zone)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc and not fc:IsAbleToHand() then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	
	Duel.BreakEffect()
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence() < 5 then
		c:CancelToGrave()
	end

	if fc then
		Duel.SendtoHand(fc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,fc)
	end
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence() < 5 then
		local ot=c:GetOriginalType()
		local remove_type=ot&(~TYPE_SPELL)
		
		if remove_type~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(remove_type)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e1,true)
		end

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_SPELL+TYPE_FIELD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2,true)

		Duel.MoveSequence(c,5)
	else
		local temp_card, temp_seq, temp_pos, temp_original_type, temp_current_type, temp_location_type
		local zone = nil
		
		if s.hasmainsz(tp) then
			zone = s.getmainzone(tp)
		else
			local sg = Duel.GetMatchingGroup(s.szfreefilter,tp,LOCATION_SZONE,0,nil)
			if #sg > 0 then
				temp_card = sg:GetFirst()
				temp_seq = temp_card:GetSequence()
				temp_pos = temp_card:GetPosition()
				temp_original_type = temp_card:GetOriginalType()
				temp_current_type = temp_card:GetType()
				zone = 1 << temp_seq
				temp_location_type = s.safeTempRemove(temp_card)
				if not temp_location_type then return end
			else
				return
			end
		end

		if not zone then return end
		
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zone)
		if not c:IsLocation(LOCATION_SZONE) then 
			if temp_card and temp_location_type then
				s.restoreTempCard(e,tp,temp_card,temp_seq,temp_pos,temp_original_type,temp_current_type,temp_location_type)
			end
			return 
		end

		local ot=c:GetOriginalType()
		local remove_type=ot&(~TYPE_SPELL)
		if remove_type~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(remove_type)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e1,true)
		end

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_SPELL+TYPE_FIELD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2,true)
		Duel.MoveSequence(c,5)
		if temp_card and temp_location_type then
			s.restoreTempCard(e,tp,temp_card,temp_seq,temp_pos,temp_original_type,temp_current_type,temp_location_type)
		end
	end
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_FZONE) and c:IsFaceup() and not c:IsPreviousLocation(LOCATION_FZONE)) then return false end
	local eff = re
	if not eff and Duel.GetCurrentChain() > 0 then
		eff = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
	end 
	if not eff then return false end
	local rc = eff:GetHandler()
	if not rc then return false end
	return rc:IsCode(40020965) or s.Soldier(rc)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
