--异热同心从者-闪光贤者
function c75038075.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038075)
	e1:SetCondition(c75038075.thcon)
	e1:SetCost(c75038075.thcost)
	e1:SetTarget(c75038075.thtg)
	e1:SetOperation(c75038075.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75038075,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75038075+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c75038075.spcost)
	e2:SetTarget(c75038075.sptg)
	e2:SetOperation(c75038075.spop)
	c:RegisterEffect(e2)
	--counter
	Duel.AddCustomActivityCounter(75038075,ACTIVITY_SPSUMMON,c75038075.counterfilter)
end
function c75038075.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function c75038075.cfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c75038075.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75038075.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c75038075.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(75038075,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75038075.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c75038075.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c75038075.thfilter(c)
	return c:IsSetCard(0x207e,0x7f,0x107e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75038075.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038075.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75038075.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(Card.IsSetCard,1,nil,0x207e) then res=res+0x1 end
	if g:IsExists(Card.IsSetCard,1,nil,0x7f) then res=res+0x2 end
	if g:IsExists(Card.IsSetCard,1,nil,0x107e) then res=res+0x4 end
	return res~=0x1 and res~=0x2 and res~=0x4
end
function c75038075.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75038075.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,c75038075.check,false,1,2)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function c75038075.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c75038075.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75038075.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(84013237)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
