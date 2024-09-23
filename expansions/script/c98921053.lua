--联络型-网罟座泽塔星人
function c98921053.initial_effect(c)
	--code
	aux.EnableChangeCode(c,64382839,LOCATION_GRAVE)
	--link summon
	aux.AddLinkProcedure(c,c98921053.matfilter,1,1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921053,0))
	e1:SetCountLimit(1,98921053)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98921053.thcon)
	e1:SetTarget(c98921053.thtg)
	e1:SetOperation(c98921053.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c98921053.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921053,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c98921053.spcon1)
	e3:SetTarget(c98921053.sptg1)
	e3:SetOperation(c98921053.spop1)
	c:RegisterEffect(e3)
end
function c98921053.matfilter(c)
	return c:IsCode(64382839) or c:IsType(TYPE_TOKEN)
end
function c98921053.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,64382839) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98921053.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c98921053.thfilter(c)
	return aux.IsCodeListed(c,64382839) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98921053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921053.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98921053.cfilter1(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
end
function c98921053.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921053.cfilter1,1,nil,tp)
end
function c98921053.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98921053.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,100,REASON_EFFECT)
end