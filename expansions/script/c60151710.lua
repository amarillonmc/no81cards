--*天晶部队 风之战神
local m=60151710
local cm=_G["c"..m]
function c60151710.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60151710)
	e1:SetCondition(cm.decon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,6011710)
	e4:SetCondition(cm.atkcon)
	e4:SetTarget(cm.atktg)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
end
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function cm.desfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b26) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thfilter(c,code)
	return not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b26)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local code=tc:GetCode()  
	if c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,code)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				g=g:Select(tp,1,1,nil)
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.filter3(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(60151710)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
	end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		local atk=g1:GetFirst():GetAttack()
		if c:IsRelateToEffect(e) and c:IsFaceup() and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
	end
end