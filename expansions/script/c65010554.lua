--天知骑士王 冈格尼尔龙王
function c65010554.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65010558,c65010554.fusfilter,1,true,true)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010554,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65010554)
	e1:SetTarget(c65010554.target)
	e1:SetOperation(c65010554.activate)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65010554,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65010555)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c65010554.descost)
	e3:SetTarget(c65010554.destg)
	e3:SetOperation(c65010554.desop)
	c:RegisterEffect(e3)
end
function c65010554.fusfilter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DRAGON)
end
function c65010554.tgfil(c)
	return (c:IsRace(RACE_DRAGON) or c:IsType(TYPE_SPELL)) and c:IsAbleToRemove()
end
function c65010554.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65010554.tgfil(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65010554.tgfil,tp,LOCATION_GRAVE,0,1,nil) and re:GetHandlerPlayer()~=tp end
	local g=Duel.SelectTarget(tp,c65010554.tgfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c65010554.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(65010554,0)) then
		Duel.NegateActivation(ev)
	end
end

function c65010554.descfil(c)
	return c:IsReleasable()
end
function c65010554.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010554.descfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65010554.descfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c65010554.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65010554.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end