--皇兽·Z·闪电
local s,id=GetID()
s.named_with_EmperorBeast=1

s.ZEUS_CODE=40020683

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020683)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end

function s.thfilter(c)
	return s.EmperorBeast(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if ((pz0 and pz0:IsCode(s.ZEUS_CODE)) or (pz1 and pz1:IsCode(s.ZEUS_CODE))) 
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if ((pz0 and pz0:IsCode(s.ZEUS_CODE)) or (pz1 and pz1:IsCode(s.ZEUS_CODE))) then
			local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
			if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsReason(REASON_EFFECT) then return false end
	local rc=c:GetReasonEffect()
	if not rc then return false end
	local rcard=rc:GetHandler()
	return rcard and s.Grandwalker(rcard)
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
