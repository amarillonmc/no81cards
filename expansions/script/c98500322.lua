--真祖之太阳神
function c98500322.initial_effect(c)
	aux.AddCodeList(c,10000000,10000010,10000020)
	aux.EnableChangeCode(c,10000010,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
 -- e0:SetDescription(aux.Stringid(98500322,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c98500322.selfspcon)
	e0:SetTarget(c98500322.selfsptg)
	e0:SetOperation(c98500322.selfspop)
	c:RegisterEffect(e0)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500322,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,98500322)
	e3:SetCondition(c98500322.actcon)
	e3:SetCost(c98500322.cpcost)
	e3:SetTarget(c98500322.cptg)
	e3:SetOperation(c98500322.cpop)
	c:RegisterEffect(e3)
	--copy2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98500322,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,98500322)
	e7:SetCondition(c98500322.actcon)
	e7:SetCost(c98500322.cpcost)
	e7:SetTarget(c98500322.cptg)
	e7:SetOperation(c98500322.cpop)
	c:RegisterEffect(e7)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98500322,2))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c98500322.rmcon)
	e5:SetCountLimit(1,98500322)
	e5:SetTarget(c98500322.distg)
	e5:SetOperation(c98500322.disop)
	c:RegisterEffect(e5)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98500322,3))
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,98520307)
	e6:SetCondition(c98500322.tkcon)
	e6:SetTarget(c98500322.tdtg)
	e6:SetOperation(c98500322.tdop)
	c:RegisterEffect(e6)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(c98500322.regop)
	c:RegisterEffect(e9)
	--tohand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98500322,4))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCountLimit(1)
	e11:SetCondition(c98500322.thscon)
	e11:SetTarget(c98500322.thstg)
	e11:SetOperation(c98500322.thsop)
	c:RegisterEffect(e11)
end
function c98500322.selfspfilter(c,tp)
	return c:IsCode(10000010) and Duel.GetMZoneCount(tp,c)>0 and c:GetFlagEffect(7373632)>0
end
function c98500322.selfspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c98500322.selfspfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c98500322.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c98500322.selfspfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c98500322.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_SPSUMMON)
end
function c98500322.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function c98500322.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98500322.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98500322.cpfilter(c)
	return ((c:GetType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)) and (aux.IsCodeListed(c,10000000) or aux.IsCodeListed(c,10000010) or aux.IsCodeListed(c,10000020) or c:IsCode(5253985,7373632,59094601,39913299,79339613,42469671,85758066,85182315,79868386)) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c98500322.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500322.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c98500322.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98500322.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		g:AddCard(e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST)
	end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c98500322.cpop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c98500322.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c98500322.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
function c98500322.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c98500322.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(98501322,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c98500322.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98500322.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	end
	Duel.SetChainLimit(c98500322.chainlm)
end
function c98500322.chainlm(re,rp,tp)
	return (re:GetHandler():IsRace(RACE_DIVINE) and not re:GetHandler():IsCode(10000090))
end
function c98500322.spfilter(c,e,tp)
	return c:IsCode(10000080) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500322.tdfilter(c)
	return c:IsCode(10000010) and c:IsAbleToDeck()
end
function c98500322.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98500322.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c98500322.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98500322,5)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98500322.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
function c98500322.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98501322)==0
end
function c98500322.thscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and not Duel.IsPlayerAffectedByEffect(tp,98500300) and c:GetFlagEffect(98500322)>0
end
function c98500322.thstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98500322.thsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c98500322.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98500322,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end