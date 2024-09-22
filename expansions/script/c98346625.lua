--女巫的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf7),aux.NonTuner(Card.IsSetCard,0xaf7),1)
	c:EnableReviveLimit()
	--ccpos
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e0)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-600)
	c:RegisterEffect(e1)
	--disabled
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346625,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(c98346625.discon)
	e2:SetTarget(c98346625.distg)
	e2:SetOperation(c98346625.disop)
	c:RegisterEffect(e2)
	--Tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346625,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(c98346625.thcon)
	e3:SetTarget(c98346625.thtg)
	e3:SetOperation(c98346625.thop)
	c:RegisterEffect(e3)
end
function c98346625.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled() and e:GetHandler():IsAttackPos()
end
function c98346625.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) and not chkc==e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and c:IsCanChangePosition() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c98346625.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) 
	and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c98346625.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and rc:IsAbleToHand() and rc:IsOnField() and e:GetHandler():IsDefensePos() and not e:GetHandler():IsDisabled()
end
function c98346625.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToHand() and rc:IsLocation(LOCATION_ONFIELD) and c:IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function c98346625.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsAbleToHand() and rc:IsFaceup() and rc:IsOnField()
	and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
	end
end