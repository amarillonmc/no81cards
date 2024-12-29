--ドッペル・チェンジャー
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,race,attr,lvl,atk,def)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(race) and c:IsAttribute(attr) and c:IsLevel(lvl) and c:IsAttack(atk) and c:IsDefense(def) and c:IsAbleToHand()
end
function s.costfilter(c)
	local race=c:GetRace()
	local attr=c:GetAttribute()
	local lvl=c:GetLevel()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	return c:IsType(TYPE_NORMAL) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,race,attr,lvl,atk,def)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g:GetFirst())
	if g:GetFirst():GetPreviousLocation()==LOCATION_HAND then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetFirstTarget()
	if not gc:IsRelateToEffect(e) then return false end
	local race=gc:GetRace()
	local attr=gc:GetAttribute()
	local lvl=gc:GetLevel()
	local atk=gc:GetAttack()
	local def=gc:GetDefense()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,race,attr,lvl,atk,def)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
