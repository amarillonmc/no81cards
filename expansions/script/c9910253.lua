--幽鬼侍者 小坂井绫
function c9910253.initial_effect(c)
	c:EnableCounterPermit(0x953)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910253)
	e1:SetCondition(c9910253.spcon)
	e1:SetOperation(c9910253.spop)
	c:RegisterEffect(e1)
	--add counter / set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910254)
	e2:SetTarget(c9910253.cttg)
	e2:SetOperation(c9910253.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(c9910253.descost)
	e4:SetTarget(c9910253.destg)
	e4:SetOperation(c9910253.desop)
	c:RegisterEffect(e4)
end
function c9910253.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x953,3,REASON_COST)
end
function c9910253.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x953,3,REASON_COST)
end
function c9910253.setfilter(c)
	return c:IsSetCard(0x953) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910253.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if c:IsCanAddCounter(0x953,2) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c9910253.setfilter,tp,LOCATION_GRAVE,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910253,0))
		sel=Duel.SelectOption(tp,aux.Stringid(9910253,1),aux.Stringid(9910253,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(9910253,1))
	else
		Duel.SelectOption(tp,aux.Stringid(9910253,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x953)
	else
		e:SetCategory(CATEGORY_LEAVE_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function c9910253.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if c:IsRelateToEffect(e) then c:AddCounter(0x953,2) end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c9910253.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9910253.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x953,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x953,2,REASON_COST)
end
function c9910253.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c9910253.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsPreviousPosition,nil,POS_FACEDOWN)
		if ct<=0 then return end
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
