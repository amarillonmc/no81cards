--进化型-网罟座泽塔星人
function c98921054.initial_effect(c)
	--code
	aux.EnableChangeCode(c,64382839,LOCATION_GRAVE)
	--link summon
	aux.AddLinkProcedure(c,c98921054.mfilter,2,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921054,0))
	e1:SetCategory(CATEGORY_DECKDES0)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98921054)
	e1:SetCondition(c98921054.thcon)
	e1:SetTarget(c98921054.thtg)
	e1:SetOperation(c98921054.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c98921054.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921054,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,98921054)
	e3:SetCondition(c98921054.thcon)
	e3:SetTarget(c98921054.rmtg)
	e3:SetOperation(c98921054.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c98921054.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98921054,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(c98921054.spcon1)
	e5:SetTarget(c98921054.sptg1)
	e5:SetOperation(c98921054.spop1)
	c:RegisterEffect(e5)
end
function c98921054.mfilter(c)
	return c:IsLinkRace(RACE_FAIRY+RACE_FIEND)
end
function c98921054.kfilter(c)
	return c:IsCode(64382839) or c:IsLinkType(TYPE_TOKEN)
end
function c98921054.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c98921054.kfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98921054.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c98921054.tgfilter(c)
	return aux.IsCodeListed(c,64382839) or c:IsCode(64382839) and c:IsAbleToHand()
end
function c98921054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921054.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98921054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98921054.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c98921054.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98921054.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c98921054.cfilter1(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
end
function c98921054.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921054.cfilter1,1,nil,tp)
end
function c98921054.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98921054.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end