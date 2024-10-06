--芳青之梦 荡思眠
function c21113845.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113845.discon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21113845)
	e1:SetCost(c21113845.cost)
	e1:SetTarget(c21113845.tg)
	e1:SetOperation(c21113845.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_TODECK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21113846)
	e2:SetCost(c21113845.cost2)
	e2:SetTarget(c21113845.tg2)
	e2:SetOperation(c21113845.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(21113845,ACTIVITY_SPSUMMON,c21113845.counter)	
end
function c21113845.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113845.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113845.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113845,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113845.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21113845.opq)
	Duel.RegisterEffect(e2,tp)
end
function c21113845.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end
function c21113845.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113845)==0 then
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c21113845.valq)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c21113845.valq)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
	Duel.ResetFlagEffect(tp,21113845)
	e:Reset()
end
function c21113845.valq(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xc914) and bit.band(loc,LOCATION_GRAVE)~=0
end
function c21113845.q(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xc914) and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c21113845.w,tp,0x12,0,1,nil,e,tp,c)
end
function c21113845.w(c,e,tp,sc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc914) and not c:IsCode(21113845)
end
function c21113845.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113845.q,tp,4,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end
function c21113845.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113845,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c21113845.q,tp,4,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c21113845.w),tp,0x12,0,1,nil,e,tp,tc) and Duel.GetLocationCount(tp,4)>0 then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21113845.w),tp,0x12,0,1,1,nil,e,tp,tc)
		if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
end
function c21113845.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(21113845,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113845.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c21113845.e(c,e,tp,mg)
	if c:GetLink()<2 then return false end
	local ct=math.floor(c:GetLink()/2)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and mg:CheckSubGroup(c21113845.check,ct,ct,tp,c)
end
function c21113845.check(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:FilterCount(Card.IsAbleToDeck,nil)==#g
end
function c21113845.r(c)
	return c:IsSetCard(0xc914) and c:IsAbleToDeck() and not c:IsCode(21113845)
end
function c21113845.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21113845.r,tp,0x30,0,nil)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.IsExistingMatchingCard(c21113845.e,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21113845.op2(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(c21113845.r,tp,0x30,0,nil)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21113845.e,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
	Duel.ConfirmCards(1-tp,tc)
	local ct=math.floor(tc:GetLink()/2)
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,c21113845.check,false,ct,ct,tp,tc)
	local cg=sg:Filter(Card.IsFacedown,nil)
	Duel.ConfirmCards(1-tp,cg)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)>0 then
		tc:SetMaterial(nil)
		Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
			end
		end
	end
end