--封灵请求
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function s.plfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6224) and not c:IsForbidden()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.thfilter(c)
	return c:IsSetCard(0x6224) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then ft=ft-1 end
	local pl=Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_HAND,0,1,nil) and ft>0
	local loc=LOCATION_DECK
	if pl then loc=loc|LOCATION_GRAVE end

	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.thfilter,tp,loc,0,1,nil)
	end
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) or (pl and Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		local tc=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			--Treated as a Continuous Spell
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
			tc:RegisterEffect(e1)
		end
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local loc=op==1 and LOCATION_DECK|LOCATION_GRAVE or LOCATION_DECK
	local ct=op==1 and 2 or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,loc,0,1,ct,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end