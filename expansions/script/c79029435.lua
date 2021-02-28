--罗德岛·医疗干员-絮雨
function c79029435.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029435.splimit1)
	c:RegisterEffect(e2)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,79029435)
	e1:SetTarget(c79029435.target)
	e1:SetOperation(c79029435.activate)
	c:RegisterEffect(e1)   
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,19029435)
	e3:SetCost(c79029435.thcost)
	e3:SetCondition(c79029435.thcon)
	e3:SetTarget(c79029435.thtg)
	e3:SetOperation(c79029435.thop)
	c:RegisterEffect(e3)  
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029435)
	e2:SetCost(c79029435.spcost)
	e2:SetTarget(c79029435.sptg)
	e2:SetOperation(c79029435.spop)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029435,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,39029435)
	e2:SetCost(c79029435.zdiscost)
	e2:SetTarget(c79029435.zdistg)
	e2:SetOperation(c79029435.zdisop)
	c:RegisterEffect(e2)
end
function c79029435.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029435.filter(c)
	local lv=c:GetLevel()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingTarget(c79029435.zfilter,tp,LOCATION_GRAVE,0,1,nil,lv) and c:IsLevelAbove(1)
end
function c79029435.zfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:GetLevel()==lv and c:IsLevelAbove(1)
end
function c79029435.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029435.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c79029435.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local lv=g:GetFirst():GetLevel()
	local xg=Duel.SelectTarget(tp,c79029435.zfilter,tp,LOCATION_GRAVE,0,1,1,nil,lv)  
	g:Merge(xg)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c79029435.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
	Debug.Message("我熟悉这死亡的气息。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029435,3))
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c79029435.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c79029435.discon)
		e2:SetOperation(c79029435.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c79029435.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c79029435.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c79029435.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c79029435.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c79029435.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c79029435.thfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c79029435.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029435.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c79029435.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("请跟紧我，不要离得太远。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029435,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029435.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029435.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c79029435.ccfilter,tp,LOCATION_EXTRA,0,lv,c)
end
function c79029435.ccfilter(c,lv)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029435.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029435.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local tc=Duel.SelectMatchingCard(tp,c79029435.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local lv=tc:GetLevel()
	local g=Duel.SelectMatchingCard(tp,c79029435.ccfilter,tp,LOCATION_EXTRA,0,lv,lv,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(tc)
end
function c79029435.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c79029435.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Debug.Message("不要害怕。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029435,1))
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79029435.zdiscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029435.filterz(c)
	return c:IsAbleToDeck()
end
function c79029435.zdistg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029435.filterz,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c79029435.filterz,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c79029435.zdisop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
	Debug.Message("睡吧。愿所有人都能在雨声里做个好梦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029435,2))
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c79029435.distgx)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c79029435.disconx)
		e2:SetOperation(c79029435.disopx)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c79029435.distgx(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c79029435.disconx(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c79029435.disopx(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
