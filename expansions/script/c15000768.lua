local m=15000768
local cm=_G["c"..m]
cm.name="幻象骑士·汞之克莱门蒂亚"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.mocon)
	e1:SetOperation(cm.moop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+15000768)
	e3:SetCountLimit(1,15000768)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
	--?
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,15000769)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	if not c15000768.global_check then
		c15000768.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+15000768,re,r,rp,ep,ev)
end
function cm.mocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return ((Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0))) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c)
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c) then return end
	if Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.MoveSequence(c,4)
	elseif Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0) then
		Duel.MoveSequence(c,0)
	end
end
function cm.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(15000810) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b1=tc:IsAbleToHand()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function cm.spfilter(c,e)
	return c:IsType(TYPE_PENDULUM) and ((c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable(e)) or (c:IsLocation(LOCATION_HAND) and c:IsAbleToExtra()))
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c,e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c,e):GetFirst()
	local x=0
	if tc then
		if tc:IsLocation(LOCATION_ONFIELD) then 
			Duel.Destroy(tc,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_HAND) then
			Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
		end
	end
	local ag=Duel.GetOperatedGroup()
	if ag:GetCount()~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.sp2filter(c,tc,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f3c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b1=(Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1)
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1) and Duel.GetFieldCard(tp,LOCATION_PZONE,1):IsDestructable(e) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,Duel.GetFieldCard(tp,LOCATION_PZONE,1),e,tp) and Duel.GetMZoneCount(tp)~=0)
	return b1 and (b2 or b3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1 end
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1) and Duel.GetFieldCard(tp,LOCATION_PZONE,1):IsDestructable(e) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,Duel.GetFieldCard(tp,LOCATION_PZONE,1),e,tp) and Duel.GetMZoneCount(tp)~=0)
	if b3 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_PZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1) and Duel.GetFieldCard(tp,LOCATION_PZONE,1):IsDestructable(e) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,Duel.GetFieldCard(tp,LOCATION_PZONE,1),e,tp) and Duel.GetMZoneCount(tp)~=0)
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==0 then return end
	local op=0
	if b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
	elseif b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(m,3))
	elseif b3 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(m,4))+1
	else return end
	if op==0 then
		local tc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,tc) then return end
		if Duel.GetFieldCard(tp,LOCATION_PZONE,0)==tc and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			Duel.MoveSequence(tc,4)
		elseif Duel.GetFieldCard(tp,LOCATION_PZONE,1)==tc and Duel.CheckLocation(tp,LOCATION_PZONE,0) then
			Duel.MoveSequence(tc,0)
		end
	end
	if op==1 then
		local tc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if Duel.Destroy(tc,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,tc,e,tp) and Duel.GetMZoneCount(tp)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ag=Duel.SelectMatchingCard(tp,cm.sp2filter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
			if ag:GetCount()~=0 then
				Duel.SpecialSummon(ag,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end