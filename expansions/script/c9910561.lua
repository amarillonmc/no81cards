--甜心机仆 临别的礼物
require("expansions/script/c9910550")
function c9910561.initial_effect(c)
	--flag
	Txjp.AddTgFlag(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3951))
	e1:SetValue(c9910561.val)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3951))
	c:RegisterEffect(e2)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,9910561)
	e4:SetCondition(c9910561.xmcon)
	e4:SetTarget(c9910561.xmtg)
	e4:SetOperation(c9910561.xmop)
	c:RegisterEffect(e4)
end
function c9910561.val(e,c)
	return e:GetHandler():GetOverlayCount()*500
end
function c9910561.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9910561.xmfilter(c,tp,e)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
		and not (e and c:IsImmuneToEffect(e))
end
function c9910561.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910561.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
end
function c9910561.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9910561.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp,e)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(tc))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910561.thcon)
		e1:SetOperation(c9910561.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910561.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetOverlayCount(tp,1,0)>0
end
function c9910561.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910561)
	local g=Duel.GetOverlayGroup(tp,1,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910561,0))
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
		Duel.ShuffleHand(1-tp)
	end
end
