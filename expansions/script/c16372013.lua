--花信之主 启灵元神
function c16372013.initial_effect(c)
	c:SetUniqueOnField(1,0,16372013)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c16372013.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0xdc1),5,127,true,true)
	aux.AddContactFusionProcedure(c,c16372013.ffilter2,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.SendtoGrave,REASON_COST)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c16372013.imcon)
	e1:SetValue(c16372013.efilter)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(116372013)
	e2:SetCondition(c16372013.copycon)
	e2:SetCost(c16372013.copycost)
	e2:SetTarget(c16372013.copytg)
	e2:SetOperation(c16372013.copyop)
	c:RegisterEffect(e2)
	--setself
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,16372013+100)
	e3:SetCondition(c16372013.setscon)
	e3:SetTarget(c16372013.setstg)
	e3:SetOperation(c16372013.setsop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c16372013.spellcon)
	e4:SetTarget(c16372013.tg)
	e4:SetOperation(c16372013.op)
	c:RegisterEffect(e4)
end
function c16372013.ffilter(c)
	return c:IsFusionSetCard(0xdc1) and c:IsFusionType(TYPE_FUSION+TYPE_LINK)
end
function c16372013.ffilter2(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c16372013.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c16372013.imfilter(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER)
end
function c16372013.imcon(e)
	local g=Duel.GetMatchingGroup(c16372013.imfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>9
end
function c16372013.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c16372013.copycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16372013.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(16372013)==0 end
	e:GetHandler():RegisterFlagEffect(16372013,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c16372013.copyfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and not c:IsType(TYPE_TOKEN+TYPE_NORMAL)
end
function c16372013.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c16372013.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16372013.copyfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c16372013.copyfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function c16372013.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN+TYPE_NORMAL) then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(16372013,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c16372013.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c16372013.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c16372013.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372013.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372013.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372013.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372013.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16372013.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c16372013.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16372013.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,dc,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:SetLabelObject(dc)
	Duel.SetChainLimit(c16372013.chainlm)
end
function c16372013.chainlm(re,rp,tp)
	return tp==rp or not re:GetHandler():IsType(TYPE_MONSTER) or re:GetHandler():IsRace(RACE_PLANT)
end
function c16372013.op(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:IsContains(dc) and dc:IsRelateToEffect(e) then
		Duel.SendtoDeck(dc,nil,2,REASON_EFFECT)
	end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)-dc
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end