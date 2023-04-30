--真神使者 鲲鹏
local m=91020020
local cm=c91020020
function c91020020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(cm.tg2)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.flipop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*2)
	e5:SetCondition(cm.condition)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(91020020,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return  c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1)
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(91020020,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e1
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 return c:IsFaceup() and c:GetFlagEffect(91020020)>0 and  not c:IsDisabled()
end

--e1
function cm.tag(e,c)
return not (c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return  Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and Duel.GetCustomActivityCount(91020020,tp,ACTIVITY_SPSUMMON)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tag)
	Duel.RegisterEffect(e1,tp)
	local c=e:GetHandler()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
end
--e2
function cm.fit(c)
	return c:IsSetCard(0x9d1) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.fite(c)
return (c:IsSetCard(0x9d1) or c:IsSetCard(0x9d0)) and c:IsSummonable(true,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_DECK,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if  Duel.IsExistingMatchingCard(cm.fite,tp,LOCATION_HAND,0,1,nil,true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.fite,tp,LOCATION_HAND,0,1,1,nil,true,nil)
	local ag=sg:GetFirst()
	if sg:GetCount()>0 then
	local pos=0
	if ag:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if ag:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,ag,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,ag,true,nil,1)
	else
		Duel.MSet(tp,ag,true,nil,1)
	end
   end
  end
end
function cm.fit2(c)
	return c:IsSetCard(0x9d0) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.fit2,tp,LOCATION_DECK,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(cm.fit2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

