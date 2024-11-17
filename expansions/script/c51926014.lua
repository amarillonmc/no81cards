--炼金兽 银月颜
function c51926014.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c51926014.splimit)
	c:RegisterEffect(e0)
	--set or search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51926014)
	e1:SetCost(c51926014.thcost)
	e1:SetTarget(c51926014.thtg)
	e1:SetOperation(c51926014.thop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c51926014.atkval)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,51926014)
	e4:SetCondition(c51926014.recon)
	e4:SetCost(c51926014.recost)
	e4:SetTarget(c51926014.retg)
	e4:SetOperation(c51926014.reop)
	c:RegisterEffect(e4)
end
function c51926014.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c51926014.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c51926014.setfilter(c,tp)
	return c:IsCode(51926001) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51926014.thfilter(c)
	return c:IsSetCard(0x6257) and c:IsAbleToHand()
end
function c51926014.cfilter(c)
	return c:IsCode(51926001) and c:IsFaceup()
end
function c51926014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c51926014.setfilter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingMatchingCard(c51926014.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c51926014.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51926014.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c51926014.setfilter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingMatchingCard(c51926014.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c51926014.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if not (b1 or b2) then return end
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(51926014,0),aux.Stringid(51926014,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c51926014.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c51926014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c51926014.atkval(e)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function c51926014.recon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ep==1-tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c51926014.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,0,LOCATION_REMOVED,3,nil) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,0,LOCATION_REMOVED,3,3,nil)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c51926014.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToRemove,nil)==5 end
end
function c51926014.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c51926014.repop)
end
function c51926014.repop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetDecktopGroup(1-tp,5)
	if #tg<5 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
