--湖畔魔女 泰妮布里雅
function c11771595.initial_effect(c)
	c:EnableReviveLimit()
	-- 特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11771595.con1)
	e1:SetTarget(c11771595.tg1)
	e1:SetOperation(c11771595.op1)
	c:RegisterEffect(e1)
	-- 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771595,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,11771595)
	e2:SetCondition(c11771595.con2)
	e2:SetTarget(c11771595.tg2)
	e2:SetOperation(c11771595.op2)
	c:RegisterEffect(e2)
	-- 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771595,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c11771595.tg3)
	e3:SetOperation(c11771595.op3)
	c:RegisterEffect(e3)
	-- 3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11771595,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,11771596)
	e4:SetTarget(c11771595.tg4)
	e4:SetOperation(c11771595.op4)
	c:RegisterEffect(e4)
end
-- 1
function c11771595.spfilter1(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c11771595.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	local lg=g:Filter(c11771595.spfilter1,nil,ATTRIBUTE_LIGHT)
	local dg=g:Filter(c11771595.spfilter1,nil,ATTRIBUTE_DARK)
	if #lg==0 or #dg==0 then return false end
	if #lg==1 and #dg==1 and lg:GetFirst()==dg:GetFirst() then return false end
	return true
end
function c11771595.tg1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	local lg=g:Filter(c11771595.spfilter1,nil,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=lg:Select(tp,1,1,nil)
	local tc1=g1:GetFirst()
	local dg=g:Filter(c11771595.spfilter1,tc1,ATTRIBUTE_DARK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=dg:Select(tp,1,1,nil)
	g1:Merge(g2)
	if #g1<2 then return false end
	g1:KeepAlive()
	e:SetLabelObject(g1)
	return true
end
function c11771595.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		g:DeleteGroup()
	end
end
-- 2
function c11771595.rmfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c11771595.cfilter2(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c11771595.con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return true end
	return not Duel.IsExistingMatchingCard(c11771595.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c11771595.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c11771595.rmfilter2(chkc) end
	if chk==0 then
		return Duel.IsExistingTarget(c11771595.rmfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil)
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11771595.rmfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11771595.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if #tg<2 then return end
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 3
function c11771595.thfilter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c11771595.disfilter3(c)
	return c:IsFaceup()
end
function c11771595.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11771595.thfilter3,tp,LOCATION_REMOVED,0,1,nil) 
		and Duel.GetFlagEffect(tp,11771595+200)==0
	local b2=Duel.IsPlayerCanDraw(tp,2) 
		and Duel.GetFlagEffect(tp,11771595+300)==0
	local b3=Duel.IsExistingMatchingCard(c11771595.disfilter3,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.GetFlagEffect(tp,11771595+400)==0
	if chk==0 then return b1 or b2 or b3 end
end
function c11771595.op3(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c11771595.thfilter3,tp,LOCATION_REMOVED,0,1,nil) 
		and Duel.GetFlagEffect(tp,11771595+200)==0
	local b2=Duel.IsPlayerCanDraw(tp,2) 
		and Duel.GetFlagEffect(tp,11771595+300)==0
	local b3=Duel.IsExistingMatchingCard(c11771595.disfilter3,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.GetFlagEffect(tp,11771595+400)==0
	local ops,opval={},{}
	if b1 then
		table.insert(ops,aux.Stringid(11771595,3))
		table.insert(opval,1)
	end
	if b2 then
		table.insert(ops,aux.Stringid(11771595,4))
		table.insert(opval,2)
	end
	if b3 then
		table.insert(ops,aux.Stringid(11771595,5))
		table.insert(opval,3)
	end
	if #ops==0 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	if sel==1 then
		Duel.RegisterFlagEffect(tp,11771595+200,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11771595.thfilter3,tp,LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		Duel.RegisterFlagEffect(tp,11771595+300,RESET_PHASE+PHASE_END,0,1)
		if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	else
		Duel.RegisterFlagEffect(tp,11771595+400,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g=Duel.SelectMatchingCard(tp,c11771595.disfilter3,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
	end
end
-- 4
function c11771595.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11771595.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
