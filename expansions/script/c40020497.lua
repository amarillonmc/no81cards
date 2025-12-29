--天人 哈罗
local s,id=GetID()
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.imtg)
	e2:SetValue(s.imval)
	c:RegisterEffect(e2)
end



function s.thfilter(c)

	return s.CelestialBeing(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.DisableShuffleCheck()

		if g:IsExists(s.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1))  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end

		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end

function s.imtg(e,c)

	return s.CelestialBeing(c) and c:IsRace(RACE_MACHINE) and bit.band(c:GetType(),TYPE_RITUAL)~=0
		and c:IsStatus(STATUS_SPSUMMON_TURN)
end

function s.imval(e,re)

	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
