--忆剑 剑萦百年
local m=77002515
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.descon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e8=e3:Clone()
	e8:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e8)
end
--Effect 1
function cm.sumfilter(c)
	return c:IsSetCard(0x3eef) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsLocation(LOCATION_HAND) then
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e2:SetOperation(cm.sumsuc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	Duel.Damage(1-p,500,REASON_EFFECT)
end
--Effect 2
function cm.cfilter(c,tp)   
	local b1=c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
	local b2=c:IsSetCard(0x3eef) or c:IsPreviousSetCard(0x3eef)
	local b3=c:IsPreviousLocation(LOCATION_GRAVE) or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP))
	local b4=c:IsLocation(LOCATION_DECK) or (c:IsLocation(LOCATION_HAND) and c:IsControler(tp)) 
	return b1 and b2 and b3 and b4
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	local fg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

