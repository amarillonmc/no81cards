local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--material loop
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	local current_p=tp
	local last_p=nil
	
	while true do
		--Check loop termination conditions (Materials >= 9 or Levels >= 21)
		local ct=c:GetOverlayCount()
		local g=c:GetOverlayGroup()
		local lv_total=0
		for tc in aux.Next(g) do
			lv_total=lv_total+tc:GetOriginalLevel()
		end
		
		if ct>=9 or lv_total>=21 then break end
		
		--Check if current player has valid cards
		local g_hand=Duel.GetMatchingGroup(s.matfilter,current_p,LOCATION_HAND,0,nil,e)
		local g_deck=Duel.GetDecktopGroup(current_p,1)
		local can_hand=g_hand:GetCount()>0
		local can_deck=g_deck:GetCount()>0 and s.matfilter(g_deck:GetFirst(),e)
		
		--If player cannot attach, loop ends
		if not can_hand and not can_deck then break end
		
		--Select source: Hand or Deck
		local op=0
		if can_hand and can_deck then
			op=Duel.SelectOption(current_p,aux.Stringid(id,1),aux.Stringid(id,2)) -- Hand, Deck
		elseif can_hand then
			op=0
		else
			op=1
		end
		
		local mat=nil
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,current_p,HINTMSG_XMATERIAL)
			mat=g_hand:Select(current_p,1,1,nil):GetFirst()
		else
			mat=g_deck:GetFirst()
		end
		
		if mat then
			Duel.ConfirmCards(current_p,mat)
			Duel.ConfirmCards(1-current_p,mat)
			Duel.DisableShuffleCheck()
			Duel.Overlay(c,Group.FromCards(mat))
			last_p=current_p
		end
		
		--Switch turn
		current_p=1-current_p
	end
	
	--Post-loop resolution
	if last_p~=nil then
		local op=Duel.SelectOption(last_p,aux.Stringid(id,3),aux.Stringid(id,4)) -- Send to GY, Gain Effect
		if op==0 then
			Duel.SendtoGrave(c,REASON_EFFECT)
		else
			--Gains Effect (Reference: Black Rose Moonlight Dragon + Lucifer)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAINING)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetOperation(s.regop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVED)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(s.damcon)
			e2:SetOperation(s.damop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetLP(1-tp)>0 and c:GetFlagEffect(id)~=0 and re:IsActiveType(TYPE_MONSTER)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local dam=e:GetHandler():GetOverlayCount()*200
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end