--窃时姬 bio
local m=51340021
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.pccon)
	e1:SetCost(cm.pccost)
	e1:SetTarget(cm.pctg)
	e1:SetOperation(cm.pcop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--xyz ma 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.xyzcon)
	e3:SetTarget(cm.xyztg)
	e3:SetOperation(cm.xyzop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsSetCard(0xa06)
end
--set
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xa06) and c:IsLocation(LOCATION_EXTRA)
end
function cm.pcfilter(c)
	return c:IsSetCard(0xa06) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		tc:RegisterFlagEffect(51340001,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--SpecialSummon
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON+RACE_PLANT) and c:IsType(TYPE_TUNER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_REMOVED,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
end
--xyz 
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	return ct1-ct2>=5 or ct2-ct1>=5
end
function cm.thfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,1,nil) or Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local count=ct1-ct2
	if count<0 then count=ct2-ct1 end
	count=count-count%5
	count=count/5
	local a=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ)
	local b=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,1,nil)
	if a or b then
		while count>0 do
			local off=1
			local ops={}
			local opval={}
			if a then
				ops[off]=aux.Stringid(m,1)
				opval[off-1]=1
				off=off+1
			end
			if b then
				ops[off]=aux.Stringid(m,2)
				opval[off-1]=2
				off=off+1
			end
			ops[off]=aux.Stringid(m,3)
			opval[off-1]=3
			off=off+1
			local op=Duel.SelectOption(tp,table.unpack(ops))
			if opval[op]==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_XYZ):GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
				Duel.Overlay(tc,g)
			end
			if opval[op]==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end
			count=count-1
		end
	end
end






