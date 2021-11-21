--魔轰神 克露贝洛丝
function c47395385.initial_effect(c)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c47395385.syncon)
	e0:SetTarget(c47395385.syntg)
	e0:SetOperation(c47395385.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47395385,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c47395385.con)
	e1:SetTarget(c47395385.target)
	e1:SetOperation(c47395385.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47395385,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c47395385.thtg)
	e2:SetOperation(c47395385.thop)
	c:RegisterEffect(e2)
end
function c47395385.synfilter(c)
	return (c:IsSetCard(0x35) and c:IsType(TYPE_MONSTER) and c:IsDiscardable(REASON_MATERIAL+REASON_SYNCHRO) and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
end
function c47395385.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local mg=Duel.GetMatchingGroup(c47395385.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) and smat:IsSetCard(0x35) then
		return Duel.CheckTunerMaterial(c,smat,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1,99,smat,mg)
end
function c47395385.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(c47395385.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) and smat:IsSetCard(0x35) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c47395385.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local g1=g:Clone()
	g1:Sub(g2)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.SendtoGrave(g2,REASON_MATERIAL+REASON_SYNCHRO+REASON_DISCARD)
	g:DeleteGroup()
	g1:DeleteGroup()
	g2:DeleteGroup()
end

function c47395385.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47395385.filter(c)
	return c:IsSetCard(0x35) and c:IsAbleToHand()
end
function c47395385.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47395385.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c47395385.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47395385.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_EFFECT+REASON_DISCARD,nil,0x35)
end
function c47395385.thfilter(c)
	return c:IsSetCard(0x35) and c:IsAbleToHand()
end
function c47395385.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47395385.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(c47395385.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c47395385.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c47395385.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
