--物语纪录·神原骏河
function c9980179.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980179,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,9980179)
	e2:SetCost(c9980179.thcost)
	e2:SetTarget(c9980179.thtg)
	e2:SetOperation(c9980179.thop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980179,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c9980179.tdcon)
	e3:SetTarget(c9980179.tdtg)
	e3:SetOperation(c9980179.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c9980179.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980179,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9980179.sumcon)
	e3:SetCost(c9980179.cost)
	e3:SetTarget(c9980179.sumtg)
	e3:SetOperation(c9980179.sumop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980179,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,99801790)
	e4:SetCondition(c9980179.descon)
	e4:SetTarget(c9980179.destg)
	e4:SetOperation(c9980179.desop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c9980179.sumsuc)
	c:RegisterEffect(e8)
end
function c9980179.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980179,5))
end 
function c9980179.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c9980179.thfilter(c,sc,cd)
	return c:IsFaceup() and c:IsSetCard(0x5bc4) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9980179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c9980179.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980179.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9980179.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c9980179.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9980179.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9980179.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if e:GetLabel()==1
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g1:GetFirst())
		and Duel.SelectYesNo(tp,aux.Stringid(9980179,4)) then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g3=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g3,1,0,0)
	end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c9980179.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local sg1=g1:Filter(Card.IsRelateToEffect,nil,e)
	if sg1:GetCount()>0 and Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)>1 then
		local tc1=sg1:GetFirst()
		local tc2=sg1:GetNext()
		if tc1:GetControler()==tc2:GetControler() and tc1:IsLocation(LOCATION_DECK) and tc2:IsLocation(LOCATION_DECK) then
			Duel.SortDecktop(tp,tc1:GetControler(),2)
		end
	end
	if e:GetLabel()==1 and g2 then
		local tc=g2:GetFirst()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end
	end
end
function c9980179.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x5bc4) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c9980179.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9980179)==0 end
	Duel.RegisterFlagEffect(tp,9980179,RESET_CHAIN,0,1)
end
function c9980179.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c9980179.sumfilter(c)
	return c:IsSetCard(0x5bc4) and c:IsSummonable(true,nil,1)
end
function c9980179.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980179.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9980179.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980179.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c9980179.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980179.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9980179.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end