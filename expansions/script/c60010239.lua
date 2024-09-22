--璞音 星转天歌
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m+10000000)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]==true
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0
		and g:GetClassCount(Card.IsRace)==#g and g:GetClassCount(Card.IsAttribute)==#g and #g~=0 then
		for uc in aux.Next(g) do
			--immune
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(cm.efilter)
			e3:SetReset(RESET_PHASE+PHASE_END)
			uc:RegisterEffect(e3)
		end
	end
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoHand(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local num=math.min(#g,#Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil))
	if num>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,num,nil)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local num2=math.min(#Duel.GetOperatedGroup(),#Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil))
			Duel.ConfirmDecktop(tp,num2)
			local cg=Duel.GetDecktopGroup(tp,num2)
			if cg:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0 then
				local hg=g:SelectSubGroup(tp,cm.spcheck,false,1,num2)
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
			end
		end
	end
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetRace)==1 and g:GetClassCount(Card.GetAttribute)==1
end