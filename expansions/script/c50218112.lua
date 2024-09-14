--炎之数码兽LV7 伽偻达兽
function c50218112.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c50218112.atkup)
	c:RegisterEffect(e1)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,50218012)
	e3:SetCost(c50218112.scost)
	e3:SetTarget(c50218112.stg)
	e3:SetOperation(c50218112.sop)
	c:RegisterEffect(e3)
end
c50218112.lvup={50218111}
c50218112.lvdn={50218111,50218110}   
function c50218112.atkfilter(c)
	return c:IsSetCard(0xcb1) and c:IsType(TYPE_MONSTER)
end
function c50218112.atkup(e,c)
	return Duel.GetMatchingGroupCount(c50218112.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
function c50218112.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50218112.sfilter(c)
	return c:IsSetCard(0xcb1) and not c:IsCode(50218112) and c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c50218112.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c50218112.sfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
end
function c50218112.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c50218112.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end