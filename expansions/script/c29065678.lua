--灵知隐者 凉合利贝罗勒
function c29065678.initial_effect(c)
	c:EnableCounterPermit(0x11af)
	c:SetCounterLimit(0x11af,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c29065678.sprcon)
	e2:SetTarget(c29065678.sprtg)
	e2:SetOperation(c29065678.sprop)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROY)
	e3:SetCondition(c29065678.ctcon)
	e3:SetOperation(c29065678.ctop)
	c:RegisterEffect(e3)	
	--Destroy Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(29065678,0))
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)   
	e4:SetCountLimit(1,29065678)
	e4:SetTarget(c29065678.ddtg)
	e4:SetOperation(c29065678.ddop)   
	c:RegisterEffect(e4)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetDescription(aux.Stringid(29065678,1))
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1,29000039)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c29065678.spcost)
	e5:SetTarget(c29065678.sptg)
	e5:SetOperation(c29065678.spop)
	c:RegisterEffect(e5)
	--2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c29065678.extg)
	e6:SetOperation(c29065678.exop)
	c:RegisterEffect(e6)   
	Duel.AddCustomActivityCounter(29065678,ACTIVITY_CHAIN,c29065678.chainfilter)
end
function c29065678.chainfilter(re,tp,cid)
	local p=Duel.GetTurnPlayer()
	return p~=tp
end
function c29065678.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,nil)
	return rg:GetCount()>=2
end
function c29065678.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:Select(tp,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c29065678.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function c29065678.ctfilter(c,tp)
	return c:IsSetCard(0x87aa)
end
function c29065678.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c29065678.ctfilter,nil,tp)
	if ct>0 and e:GetHandler():IsCanAddCounter(0x11af,1) then
		return true
	else
		return false
	end
end
function c29065678.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x11af,1)
end
function c29065678.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0x87aa) and Duel.IsPlayerCanDraw(tp,1) end
	local tc=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,nil,0x87aa)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_ONFIELD)
end
function c29065678.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
	if Duel.Destroy(tc,REASON_EFFECT) then
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)	
	end
	end
end
function c29065678.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x11af,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x11af,1,REASON_COST)
end
function c29065678.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065678.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c29065678.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c29065678.sfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c29065678.sfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29065678.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065678.exfil(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK) and c:IsSetCard(0x87aa)
end
function c29065678.extg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29065678.exfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29065678.exfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCustomActivityCount(29065678,1-tp,ACTIVITY_CHAIN)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c29065678.exfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29065678.exop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end