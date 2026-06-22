--英杰的勇劫 赫拉克·卡俄斯
local s,id=GetID()
s.named_with_Soldier=1

function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.plcost)
	e2:SetTarget(s.pltg)
	e2:SetOperation(s.plop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+2)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.thfilter(c)
	return s.Soldier(c) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg1 and #sg1==2 then
		if Duel.SendtoHand(sg1,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg1)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect() 
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			if #hg==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local drop1=hg:Select(tp,1,1,nil):GetFirst()
			if s.Soldier(drop1) then
				if #hg>1 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local drop2=hg:Select(tp,1,1,drop1):GetFirst()
					local dropg=Group.FromCards(drop1,drop2)
					Duel.SendtoGrave(dropg,REASON_EFFECT)
				else
					Duel.SendtoGrave(drop1,REASON_EFFECT)
				end
			else
				if #hg>1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local drop2=hg:Select(tp,1,1,drop1):GetFirst()
					local dropg=Group.FromCards(drop1,drop2)
					Duel.SendtoGrave(dropg,REASON_EFFECT)
				else
					Duel.SendtoGrave(drop1,REASON_EFFECT)
				end
			end
		end
	end
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

function s.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.plfilter(c,e,tp)
	if not s.Soldier(c) then return false end
	if c:IsType(TYPE_FIELD) then return true end
	return s.hasmainsz(tp) or Duel.IsExistingMatchingCard(s.szfreefilter,tp,LOCATION_SZONE,0,1,nil)
end

function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.plfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.plfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.plfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end

function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
	end
	if tc:IsType(TYPE_FIELD) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
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
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zone)
		if not tc:IsLocation(LOCATION_SZONE) then 
			if temp_card and temp_location_type then
				s.restoreTempCard(e,tp,temp_card,temp_seq,temp_pos,temp_original_type,temp_current_type,temp_location_type)
			end
			return 
		end
		local ot=tc:GetOriginalType()
		local remove_type=ot&(~TYPE_SPELL)
		if remove_type~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(remove_type)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1,true)
		end

		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_SPELL+TYPE_FIELD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e2,true)

		Duel.MoveSequence(tc,5)
		
		if temp_card and temp_location_type then
			s.restoreTempCard(e,tp,temp_card,temp_seq,temp_pos,temp_original_type,temp_current_type,temp_location_type)
		end
	end
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
