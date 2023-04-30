--真神使者 幽冥貔貅
local m=91020022
local cm=c91020022
function c91020022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*2)
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
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*3)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(91020022,ACTIVITY_SPSUMMON,cm.counterfilter)
end
--e1
function cm.counterfilter(c)
	return  c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1)
end
function cm.tag(e,c)
return not c:IsSetCard(0x9d0) and not c:IsSetCard(0x9d1) 
end
function cm.hspfilter(c,ft,tp)
	return c:IsFacedown() and c:IsDefensePos()  
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return  Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp)and Duel.GetCustomActivityCount(91020022,tp,ACTIVITY_SPSUMMON)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
		local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)
		Duel.Release(g,REASON_COST)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e11:SetCountLimit(1)
		e11:SetCondition(cm.spcon)
		e11:SetOperation(cm.spop)
		local e12=e11:Clone()
		e11:SetCode(EVENT_PHASE+PHASE_END)   
		if Duel.GetCurrentPhase()<=PHASE_END then
		e11:SetReset(RESET_PHASE+PHASE_END,2)
		e12:SetReset(RESET_PHASE+PHASE_END,2)
		else
		e11:SetReset(RESET_PHASE+PHASE_END)
		e12:SetReset(RESET_PHASE+PHASE_END)
		end
		Duel.RegisterEffect(e11,tp)
		Duel.RegisterEffect(e12,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(cm.tag)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	local tc=g:GetFirst()
	while tc do
	local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
--e4
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(91020022,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e5
function cm.spfilter(c,e)
	return  c:IsSetCard(0x9d1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 return c:IsFaceup() and c:GetFlagEffect(91020022)>0 and  not c:IsDisabled()
end
function cm.thfilter(c)
	return  c:IsAbleToHand()
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(3040496,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end