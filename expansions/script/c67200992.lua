--真樱修正者 星仪
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pcon)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.econ)
	e2:SetTarget(s.etg)
	e2:SetOperation(s.eop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1190)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,id+2)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function s.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function s.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x567A) and not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoExtraP(c,nil,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end