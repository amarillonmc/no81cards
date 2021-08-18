local m=15000766
local cm=_G["c"..m]
cm.name="幻象骑士·金之格雷斯"
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
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
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
	e3:SetCode(EVENT_CUSTOM+15000766)
	e3:SetCountLimit(1,15000766)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
	--?
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,15000767)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not c15000766.global_check then
		c15000766.global_check=true
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
	Duel.RaiseEvent(eg,EVENT_CUSTOM+15000766,re,r,rp,ep,ev)
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
function cm.filter(c)
	return c:IsAbleToHand() and c:IsCanHaveCounter(0xf3c,1) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
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
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b1=(Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1)
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.IsPlayerCanDraw(tp,2))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1))
	return b1 and (b2 or b3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1 end
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.IsPlayerCanDraw(tp,2))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1))
	if b2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if b3 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3f3c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.IsPlayerCanDraw(tp,2))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1))
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==0 then return end
	local op=0
	if b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
	elseif b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(m,3))
	elseif b3 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(m,4))+1
	else return end
	if op==0 then
		local tc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		if tc then
			Duel.HintSelection(Group.FromCards(tc))
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then Duel.Draw(tp,2,REASON_EFFECT) end
		end
	end
	if op==1 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end