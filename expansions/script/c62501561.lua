--联协意志 盖亚终端
function c62501561.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c62501561.imcon)
	e1:SetValue(c62501561.efilter)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501561,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,62501561)
	e2:SetCondition(c62501561.setcon)
	e2:SetTarget(c62501561.settg)
	e2:SetOperation(c62501561.setop)
	c:RegisterEffect(e2)
	--return grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501561,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,62501561+1)
	e3:SetCondition(c62501561.rtcon)
	e3:SetTarget(c62501561.rttg)
	e3:SetOperation(c62501561.rtop)
	c:RegisterEffect(e3)
end
function c62501561.chkfilter(c)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c62501561.imcon(e)
	return Duel.IsExistingMatchingCard(c62501561.chkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c62501561.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c62501561.cfilter(c)
	return c:IsSetCard(0xea3) and c:IsFaceup()
end
function c62501561.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c62501561.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c62501561.setfilter(c)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c62501561.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501561.setfilter,tp,LOCATION_DECK+0x10,0,1,nil) end
end
function c62501561.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c62501561.setfilter),tp,LOCATION_DECK+0x10,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 and sc:IsType(TYPE_QUICKPLAY) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(62501561,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
function c62501561.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsSetCard(0xea3)
end
function c62501561.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501561.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c62501561.thfilter(c)
	return c:IsSetCard(0xea3) and c:IsAbleToHand()
end
function c62501561.gcheck(sg,g)
	return (sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==1 or g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0) and (sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==0)
end
function c62501561.rtop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501561.splimit)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c62501561.cfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)==0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 and Duel.SelectYesNo(tp,aux.Stringid(62501561,3)) then
		Duel.ConfirmDecktop(tp,6)
		local g=Duel.GetDecktopGroup(tp,6):Filter(c62501561.thfilter,nil)
		local g2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(c62501561.thfilter,nil)
		g:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c62501561.gcheck,false,0,2,g)
		if not sg then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c62501561.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
