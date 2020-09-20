--fate·迦摩
function c9981589.initial_effect(c)
	  c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9981589.matfilter,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9981589.efilter)
	c:RegisterEffect(e1)
 --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981589,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9981589)
	e1:SetCondition(c9981589.thcon)
	e1:SetTarget(c9981589.thtg)
	e1:SetOperation(c9981589.thop)
	c:RegisterEffect(e1)
 --atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9981589.atkcon)
	e2:SetValue(3000)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981589.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981589.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981589,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9981589,1))
end
function c9981589.matfilter(c)
	return c:IsLinkSetCard(0xba5) 
end
function c9981589.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c9981589.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9981589.thfilter(c)
	return c:IsSetCard(0x3ba8) and c:IsAbleToHand()
end
function c9981589.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981589.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981589.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981589.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9981589.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3ba8) and c:GetCode()~=9981589
end
function c9981589.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c9981589.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end