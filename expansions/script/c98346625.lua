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
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346625,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(c98346625.descon)
	e2:SetTarget(c98346625.destg)
	e2:SetOperation(c98346625.desop)
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
function c98346625.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c98346625.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c98346625.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c98346625.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98346625.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsCanChangePosition() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98346625.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98346625.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) 
	and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
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