--幽魔之忘却
local s,id=GetID()
s.named_with_Darkling=1

s.NYX_CODE=40021115
s.COUNTER_DARKLING=0x2f1e

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)
	aux.AddCodeList(c,s.NYX_CODE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.lvcon)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end

function s.nyx_faceup_filter(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE)
end

function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local ex = Duel.IsExistingMatchingCard(s.nyx_faceup_filter,tp,LOCATION_EXTRA,0,1,nil)
	local pz0 = Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1 = Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local pz = ((pz0 and pz0:IsCode(s.NYX_CODE)) or (pz1 and pz1:IsCode(s.NYX_CODE)))
	return ex or pz
end

function s.starfilter(c)
	if not c:IsFaceup() or c:IsType(TYPE_LINK) then return false end
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()~=3
	else
		return c:GetLevel()~=3
	end
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.starfilter,tp,0,LOCATION_MZONE,1,nil) end
	if Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	end
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.starfilter,tp,0,LOCATION_MZONE,nil)
	local changed = false
	
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			if tc:IsType(TYPE_XYZ) then
				e1:SetCode(EFFECT_CHANGE_RANK)
			else
				e1:SetCode(EFFECT_CHANGE_LEVEL)
			end
			e1:SetValue(3)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			if tc:RegisterEffect(e1) then
				changed = true
			end
		end
	end
	
	if changed and Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then
		
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			Duel.BreakEffect()
			Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_EFFECT)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #sg>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_DECK) then return false end
	if not c:IsReason(REASON_EFFECT) then return false end
	
	local rc=c:GetReasonEffect()
	if not rc then return false end
	local rcard=rc:GetHandler()
	return rcard and (s.Grandwalker(rcard) or s.Darkling(rcard))
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.nyx_add_filter(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE) and c:IsCanAddCounter(s.COUNTER_DARKLING,1)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
		
		local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		local valid0 = (pz0 and s.nyx_add_filter(pz0))
		local valid1 = (pz1 and s.nyx_add_filter(pz1))
		
		if (valid0 or valid1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			if valid0 and valid1 then
				local pg=Group.FromCards(pz0, pz1)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
				local tc=pg:Select(tp,1,1,nil):GetFirst()
				if tc then
					tc:AddCounter(s.COUNTER_DARKLING,1)
				end
			elseif valid0 then
				pz0:AddCounter(s.COUNTER_DARKLING,1)
			elseif valid1 then
				pz1:AddCounter(s.COUNTER_DARKLING,1)
			end
		end
	end
end
