--孤高隐士 究极骑士阿尔法兽
function c16349001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xdc3),9,4,c16349001.ovfilter,aux.Stringid(16349001,0),3,c16349001.xyzop0)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349001,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349001.target)
	e1:SetOperation(c16349001.operation)
	c:RegisterEffect(e1)
	--xmaterial
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16349001,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,16349001)
	e2:SetCondition(c16349001.xmcon)
	e2:SetTarget(c16349001.xmtg)
	e2:SetOperation(c16349001.xmop)
	c:RegisterEffect(e2)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16349001,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CUSTOM+16349001)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,16349001+1)
	e3:SetCondition(c16349001.nacon)
	e3:SetOperation(c16349001.naop)
	c:RegisterEffect(e3)
	if not c16349001.mataddcheck then
		c16349001.mataddcheck=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(card,param)
			_Overlay(card,param)
			if card:IsCode(16349001) then
				Duel.RaiseEvent(param,EVENT_CUSTOM+16349001,nil,REASON_EFFECT,0,0,0)
			end
		end
	end
end
function c16349001.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(7) and c:IsSetCard(0xdc3)
end
function c16349001.xyzop0(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	mc:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c16349001.pfilter(c,tp)
	return c:IsCode(16349049) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349001.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349001.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349001.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349001.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16349001.xmfilter(c)
	return c:IsSetCard(0xdc3,0x3dc2) and c:IsCanOverlay()
end
function c16349001.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c16349001.xmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c16349001.rmfilter(c,type)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(type)
end
function c16349001.xmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c16349001.xmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>=0 then
		local oc=g:GetFirst()
		local type=oc:GetType()&0x7
		Duel.Overlay(e:GetHandler(),oc)
		local rg=Duel.GetMatchingGroup(c16349001.rmfilter,tp,0,LOCATION_ONFIELD,nil,type)
		if oc:IsLocation(LOCATION_OVERLAY) and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(16349001,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=rg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.Remove(sg,POS_FACEUP,0x40)
		end
	end
end
function c16349001.matcheck(c,g)
	return g:IsContains(c)
end
function c16349001.nacon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()>0 and eg:IsExists(c16349001.matcheck,1,nil,g)
end
function c16349001.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c16349001.atktarget)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c16349001.atktarget(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end