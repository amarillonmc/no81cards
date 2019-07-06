--Tipi, the Blue Little Lady
--AlphaKretin
--For Nemoma
function c33700401.initial_effect(c)
	c:EnableCounterPermit(0x441)
	--place counters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82821760,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c33700401.ctcon)
	e1:SetTarget(c33700401.cttg)
	e1:SetOperation(c33700401.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86585274,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c33700401.spcost)
	e2:SetTarget(c33700401.sptg)
	e2:SetOperation(c33700401.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c33700401.tgtg)
	e3:SetOperation(c33700401.tgop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79798060,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROY)
	e4:SetCondition(c33700401.thcon)
	e4:SetTarget(c33700401.thtg)
	e4:SetOperation(c33700401.thop)
	c:RegisterEffect(e4)
end
function c33700401.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c33700401.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x441)
end
function c33700401.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():AddCounter(0x441,2)
end
function c33700401.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,c)
	e:SetLabel(g:GetCount())
	Duel.SendtoGrave(g,REASON_COST)
end
function c33700401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x441)
end
function c33700401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		e:GetHandler():AddCounter(0x441,e:GetLabel())
	end
end
function c33700401.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if c33700401.hftg(e,tp,eg,ep,ev,re,r,rp,chk) then sel=sel+1 end
		if c33700401.dktg(e,tp,eg,ep,ev,re,r,rp,chk) then sel=sel+2 end
		e:SetLabel(sel)
		return true
	end
	local sel=e:GetLabel()
	if sel>2 then
		local p=1-tp
		if c:IsCanRemoveCounter(tp,0x441,1,REASON_COST) and c:GetCounter(0x441)>1 and Duel.SelectYesNo(tp,aux.Stringid(33700401,2)) then
			c:RemoveCounter(tp,0x441,1,REASON_COST)
			p=tp
		end
		sel=Duel.SelectOption(p,aux.Stringid(33700401,0),aux.Stringid(33700401,1))+1
	end
	if sel==1 then c33700401.hftg(e,tp,eg,ep,ev,re,r,rp,chk) elseif sel==2 then c33700401.dktg(e,tp,eg,ep,ev,re,r,rp,chk) end
	e:SetLabel(sel)
end
function c33700401.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel<1 or sel>2 then return end
	if sel==1 then c33700401.hfop(e,tp,eg,ep,ev,re,r,rp) else c33700401.dkop(e,tp,eg,ep,ev,re,r,rp) end
end
function c33700401.hftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x441)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c33700401.hfop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x441)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,ct,ct,nil)
	Duel.SendtoGrave(g,REASON_RULE)
end
function c33700401.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x441)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c33700401.dkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x441)
	Duel.DiscardDeck(1-tp,ct,REASON_RULE)
end
function c33700401.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x441)
	e:SetLabel(ct)
	return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and not c:IsReason(REASON_BATTLE) and re and re:GetOwner()~=c
end
function c33700401.thtg(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33700401.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end