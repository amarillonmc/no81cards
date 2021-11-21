--卡多克·泽姆露普斯
function c16161010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
-------------P effect
	--cannot sendtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16161010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,16161010)
	e1:SetCost(c16161010.cscost)
	e1:SetTarget(c16161010.cstarget)
	e1:SetOperation(c16161010.csoperation)
	c:RegisterEffect(e1) 
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c16161010.splimit)
	c:RegisterEffect(e2)
-----------Monster Effect
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(16161010,1))
	e1_1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e1_1:SetType(EFFECT_TYPE_IGNITION)
	e1_1:SetCode(EVENT_FREE_CHAIN)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCountLimit(1)
	e1_1:SetTarget(c16161010.thtarget)
	e1_1:SetOperation(c16161010.thoperation)
	c:RegisterEffect(e1_1) 
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(16161010,4))
	e2_1:SetCategory(CATEGORY_TOHAND)
	e2_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2_1:SetCode(EVENT_BE_MATERIAL)
	e2_1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2_1:SetCondition(c16161010.reccon)
	e2_1:SetTarget(c16161010.rectg)
	e2_1:SetOperation(c16161010.recop)
	c:RegisterEffect(e2_1)
end
function c16161010.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c16161010.thfilter(c)
	return c:IsAbleToHand() and c:IsLevel(10) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c16161010.cstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16161010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,0)
end
function c16161010.csoperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(c16161010.thfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c16161010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c16161010.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsLevel(10) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c16161010.thfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function c16161010.tefilter(c)
	return c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM)
end
function c16161010.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16161010.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c16161010.tefilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,nil,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,0)
end
function c16161010.thoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c16161010.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToExtra,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16161010,2))
		local g=Duel.SelectMatchingCard(tp,c16161010.tefilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoExtraP(g,tp,REASON_EFFECT)~=0 then
				Duel.Recover(tp,(g:GetFirst():GetLevel()+g:GetFirst():GetRank())*500,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local thg=Duel.SelectMatchingCard(tp,c16161010.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
				if thg:GetCount()>0 then
					Duel.SendtoHand(thg,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,thg)
				end
			end
		end
	end
end

function c16161010.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsType(TYPE_RITUAL) and r & REASON_RITUAL+REASON_SPSUMMON ~=0 
end
function c16161010.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c16161010.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16161010.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c16161010.recop(e,tp,eg,ep,ev,re,r,rp)
	 if not Duel.IsExistingMatchingCard(c16161010.filter,tp,LOCATION_EXTRA,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16161010.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		tc=g:GetFirst()
		if not tc:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(16161010,3)) then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,tc)
		end
	end
end
