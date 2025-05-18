--艾奇军团·抉择
function c60151195.initial_effect(c)
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151195+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60151195.target)
	e1:SetOperation(c60151195.activate)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151195,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c60151195.e2tg)
	e2:SetOperation(c60151195.e2op)
	c:RegisterEffect(e2)
	
	--3xg
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60151195,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetTarget(c60151195.thtg)
	e4:SetOperation(c60151195.thop)
	c:RegisterEffect(e4)
end

c60151195.toss_coin=true

--1xg

function c60151195.targetf(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60151195.targetff(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60151195.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151195.targetf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c60151195.targetff,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c60151195.activatef(c,tp)
	return not c:IsCode(60151195)
end
function c60151195.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60151195.targetf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c60151195.targetff,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--2xg

function c60151195.e2tgf(c)
	return c:IsAbleToGrave()
end
function c60151195.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151195.e2tgf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60151195.e2tgf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151195.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60151195.e2tgf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--3xg

function c60151195.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151195.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		--if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)>0 then
			--local g8=Duel.GetMatchingGroup(c60151195.activatef,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
			--if g8:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151195,0)) then
				--Duel.BreakEffect()
				--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				--local sg=g8:Select(tp,1,1,nil)
				--Duel.SendtoGrave(sg,REASON_EFFECT)
			--end
		--end
	end
end