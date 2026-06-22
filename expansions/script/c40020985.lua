--勇劫超神星 齐格·卡俄斯
local s,id=GetID()
s.named_with_Soldier=1

function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.actcon)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2b)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,id+3)
	e3:SetCondition(s.lvcon)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
	s.soldier_field_effect = e3
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id+2)
	e4:SetTarget(s.reptg)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
	
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

function s.pcfilter(c)
	return c:IsCode(40020965)
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_PZONE,0,1,nil)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if chk==0 then 
		if fc and not fc:IsAbleToHand() then return false end
		return true 
	end
	if fc then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,fc,1,0,0)
	end
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoHand(fc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,fc)
	end
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

function s.desfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ+TYPE_LINK) and not c:IsStatus(STATUS_NO_LEVEL)
end

function s.lvsum(g)
	local sum=0
	for tc in aux.Next(g) do
		sum = sum + tc:GetLevel()
	end
	return sum <= 8
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:CheckSubGroup(s.lvsum,1,99) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.lvsum,false,1,99)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	local g = tg:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local sum_atk=0
		for tc in aux.Next(og) do
			local atk = tc:GetPreviousAttackOnField()
			if atk>0 then sum_atk = sum_atk + atk end
		end
		if sum_atk>0 then
			Duel.Recover(tp,sum_atk,REASON_EFFECT)
		end
	end
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetDestination()==LOCATION_DECK 
			and c:IsReason(REASON_EFFECT)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,c:GetOriginalType(),c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		return true
	end
	return false
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
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

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,12)
	
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetLabel(lv)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
end

function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLevel(e:GetLabel())
end
