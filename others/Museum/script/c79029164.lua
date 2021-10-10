--罗德岛·重装干员-卡缇
function c79029164.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029164.mfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14812471,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,14812471)
	e1:SetCondition(c79029164.thcon)
	e1:SetTarget(c79029164.thtg)
	e1:SetOperation(c79029164.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c79029164.reptg)
	e2:SetValue(c79029164.repval)
	e2:SetOperation(c79029164.repop)
	c:RegisterEffect(e2)	
end
function c79029164.mfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xa900)
end
function c79029164.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029164.thfilter(c)
	return c:IsSetCard(0xa90f) and c:IsAbleToHand()
end
function c79029164.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029164.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029164.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("了解！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029164,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029164.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029164.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa900)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c79029164.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c79029164.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c79029164.repval(e,c)
	return c79029164.repfilter(c,e:GetHandlerPlayer())
end
function c79029164.repop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("你们的攻击毫无意义！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029164,1))
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
