--人理之基 乙姬清姬
function c22023470.initial_effect(c)
	aux.AddCodeList(c,22702055,22020010)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),3,2,c22023470.ovfilter,aux.Stringid(22023470,0))
	c:EnableReviveLimit()
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c22023470.disop)
	c:RegisterEffect(e1)
	--remove material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023470,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22023470.rmtg)
	e2:SetOperation(c22023470.rmop)
	c:RegisterEffect(e2)
end
function c22023470.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22020010) and Duel.IsEnvironment(22702055)
end
function c22023470.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep==tp or e:GetHandler():GetOverlayCount()<1 or not (re:IsActiveType(TYPE_MONSTER) and rc~=c and not rc:IsCode(rc:GetOriginalCodeRule())) then return end
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c22023470.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c22023470.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
