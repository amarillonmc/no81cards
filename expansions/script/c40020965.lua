local s,id=GetID()
s.named_with_Primordial=1
s.named_with_Grandwalker=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.actcon)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
end

function s.thfilter(c)
	return s.Soldier(c) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
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

function s.szfreefilter(c,e,tp)
	if c:GetSequence()>=5 then return false end
	return c:IsAbleToRemove() or c:IsAbleToGrave() or c:IsAbleToDeck()
end

function s.canplacefieldfromgrave(c,e,tp)
	if c:IsType(TYPE_FIELD) then return true end
	return s.hasmainsz(tp) or Duel.IsExistingMatchingCard(s.szfreefilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
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
	return temp_card:IsLocation(LOCATION_SZONE)
end

function s.cfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_HAND)
		and c:IsControler(tp)
		and s.Soldier(c)
		and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeEffectTarget(e)
		and s.canplacefieldfromgrave(c,e,tp)
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.cfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,s.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		if op==0 then Duel.SendtoDeck(fc,nil,SEQ_DECKTOP,REASON_EFFECT)
		else Duel.SendtoDeck(fc,nil,SEQ_DECKBOTTOM,REASON_EFFECT) end
	end
	if tc:IsType(TYPE_FIELD) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		local temp_card, temp_seq, temp_pos, temp_original_type, temp_current_type, temp_location_type
		local zone = nil
		
		if s.hasmainsz(tp) then
			zone = s.getmainzone(tp)
		else
			local sg = Duel.GetMatchingGroup(s.szfreefilter,tp,LOCATION_SZONE,0,nil,e,tp)
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
	if tc:IsLocation(LOCATION_FZONE) then
		local te=tc:GetActivateEffect()
		if te then
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if s.Grandwalker(rc) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetFlagEffect(tp,id)==0 then
			if Duel.IsPlayerCanDiscardDeck(tp,4) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end