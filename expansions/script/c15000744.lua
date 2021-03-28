local m=15000744
local cm=_G["c"..m]
cm.name="噩梦茧机致幻"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.dscon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,15000744)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--change ATK&DEF
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCountLimit(1,15000745)
	e4:SetCondition(cm.adcon)
	e4:SetTarget(cm.adtg)
	e4:SetOperation(cm.adop)
	c:RegisterEffect(e4)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)  
	return ((e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsSetCard(0x6f38) and re:IsActivated()) or (e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x6f38))) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function cm.swfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetAttack()~=c:GetDefense()
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.swfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.swfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		if tc:IsSetCard(0x6f38) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end