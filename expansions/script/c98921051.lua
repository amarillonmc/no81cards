--UFO-绝密档案
function c98921051.initial_effect(c)
	aux.AddCodeList(c,64382839)	
	c:SetUniqueOnField(1,0,98921051)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921051,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c98921051.rmcost)
	e1:SetTarget(c98921051.rmtg)
	e1:SetOperation(c98921051.rmop)
	c:RegisterEffect(e1)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98921051,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c98921051.settg)
	e4:SetOperation(c98921051.setop)
	c:RegisterEffect(e4)
end
function c98921051.costfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c98921051.fselect(g,tp)
	return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c98921051.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(c98921051.costfilter,nil)
	if chk==0 then return g:CheckSubGroup(c98921051.fselect,1,1,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c98921051.fselect,false,1,1,tp)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
end
function c98921051.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98921051.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98921051.sfilter(c)
	return aux.IsCodeListed(c,64382839) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98921051.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98921051.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921051.sfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c98921051.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c98921051.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SSet(tp,tc) end
end