--临魔浮生
function c33310158.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c33310158.mfilter,c33310158.xyzcheck,2,2)
	 --special summon (hand)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c33310158.spcon1)
	e1:SetTarget(c33310158.sptg1)
	e1:SetOperation(c33310158.spop1)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	e2:SetCost(c33310158.efcost)
	e2:SetTarget(c33310158.eftg)
	e2:SetOperation(c33310158.efop)
	c:RegisterEffect(e2)
	c33310158[c]=e1
end
function c33310158.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c33310158.thfilter(c)
	return c:IsSetCard(0x55b) and c:IsAbleToHand()
end
function c33310158.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsSetCard(0x55b) and ((c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33310158.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(true,true,false)~=nil))
end
function c33310158.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(c33310158.filter,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	local tc=og:FilterSelect(tp,c33310158.filter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local op=99
	if tc:IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
		op=0
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		local te=tc:CheckActivateEffect(true,true,false)
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
		op=1
	end
	e:SetLabel(op)
end
function c33310158.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.SelectMatchingCard(tp,c33310158.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
		if g then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	elseif op==1 then
		local te=e:GetLabelObject()
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end


function c33310158.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4)
end
function c33310158.xyzcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x55b)
end
function c33310158.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33310158.spfilter1(c)
	return c:IsSetCard(0x55b) and c:IsAbleToHand()
end
function c33310158.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310158.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33310158.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33310158.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end