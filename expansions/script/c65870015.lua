--Protoss·水晶塔
function c65870015.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--immume
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65870015.econ)
	e1:SetValue(c65870015.efilter)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870015,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,65870015)
	e2:SetTarget(c65870015.sptg)
	e2:SetOperation(c65870015.spop)
	c:RegisterEffect(e2)
end

function c65870015.sumfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a37)
end
function c65870015.econ(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870015.sumfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c65870015.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c65870015.thfilter(c)
	return c:IsSetCard(0x3a37) and c:IsType(TYPE_SPELL+TYPE_MONSTER) and c:IsAbleToHand()
end
function c65870015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870015.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65870015.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65870015.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end