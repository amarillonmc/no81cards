--终墟消抹
local m=30015065
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.allop2(c)
end
c30015065.isoveruins=true
--all
--Effect 1
function cm.setf(c) 
	local tp=c:GetControler()
	local loc=c:GetLocation()
	local chk
	if not c:IsCanTurnSet() then return false end
	if loc==LOCATION_PZONE and c:IsType(TYPE_PENDULUM) then return false end
	if loc==LOCATION_MZONE then
		chk= c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else
		chk= c:IsSSetable(true)
	end
	return c:IsFaceup() and chk
end   
function cm.negfilter(c)
	return aux.NegateAnyFilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local res=0
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		if tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_CHAIN)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		res=1
	end
	if res>0 then
		tc:CancelToGrave()
		local wp=tc:GetControler()
		local b1=tc:IsAbleToHand()
		local b2=cm.setf(tc) 
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			local loc=tc:GetLocation()
			if loc~=LOCATION_MZONE then
				if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then return false end
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,wp,0)
			else
				local pz
				if tc:IsType(TYPE_FIELD) then pz=LOCATION_FZONE else pz=LOCATION_SZONE end
				if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then return false end
				Duel.MoveToField(tc,tp,wp,pz,POS_FACEDOWN,false)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,wp,0)
			end
		end
		Duel.BreakEffect()
		ors.exrmop(e,tp,res)
	end
end