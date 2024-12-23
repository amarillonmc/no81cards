--辉耀紫炎蔷薇的勇气
function c9911572.initial_effect(c)
	c:SetSPSummonOnce(9911572)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x6952),1,1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911572,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9911572.spcon)
	e2:SetTarget(c9911572.sptg)
	e2:SetOperation(c9911572.spop)
	c:RegisterEffect(e2)
	--level change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c9911572.lvcost)
	e3:SetTarget(c9911572.lvtg)
	e3:SetOperation(c9911572.lvop)
	c:RegisterEffect(e3)
end
function c9911572.tefilter(c,tp,sc)
	return c:IsSetCard(0x6952) and c:IsType(TYPE_PENDULUM) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c9911572.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9911572.tefilter,tp,LOCATION_PZONE,0,1,nil,tp,c)
end
function c9911572.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9911572.tefilter,tp,LOCATION_PZONE,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911572,1))
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c9911572.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
end
function c9911572.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9911572.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsType(TYPE_PENDULUM)
end
function c9911572.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911572.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911572.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9911572.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9911572.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsRelateToEffect(e) then
		local minlv=1-tc:GetLevel()
		if minlv<-3 then minlv=-3 end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911572,2))
		local lv=Duel.AnnounceLevel(tp,minlv,3,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
	end
end
