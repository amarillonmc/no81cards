--剑域修武士 瀚宙
function c9911715.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911715.spcon)
	e1:SetTarget(c9911715.sptg)
	e1:SetOperation(c9911715.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,9911715)
	e2:SetCondition(c9911715.thcon)
	e2:SetTarget(c9911715.thtg)
	e2:SetOperation(c9911715.thop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9911715.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	if not c9911715.global_check then
		c9911715.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911715.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911715.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911715.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911715.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911715.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911715.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911705)==0
end
function c9911715.spfilter(c,tp)
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return c:GetFlagEffect(9911705)~=0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==#g and Duel.GetMZoneCount(tp,g)>0
end
function c9911715.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9911715.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c9911715.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9911715.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		local rg=tc:GetColumnGroup()
		rg:AddCard(tc)
		rg:KeepAlive()
		e:SetLabelObject(rg)
		return true
	else return false end
end
function c9911715.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c9911715.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9911715.thfilter(c)
	return not c:IsCode(9911715) and c:IsSetCard(0x9957) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9911715.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911715.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911715.rthfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9911715.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911715.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c9911715.rthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9911715,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local rg=Duel.SelectMatchingCard(tp,c9911715.rthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(rg)
			Duel.SendtoHand(rg,nil,REASON_EFFECT)
		end
	end
end
function c9911715.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_RELEASE)
end
