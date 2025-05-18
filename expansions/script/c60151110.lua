--艾奇军团 引诱者
function c60151110.initial_effect(c)
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151110,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60151110)
	e1:SetCost(c60151110.e1cost)
	e1:SetTarget(c60151110.e1tg)
	e1:SetOperation(c60151110.e1op)
	c:RegisterEffect(e1)


	--2xg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151110,4))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,6011110)
	e3:SetCondition(c60151110.spcon)
	e3:SetTarget(c60151110.sptg)
	e3:SetOperation(c60151110.spop)
	c:RegisterEffect(e3)
end

c60151110.toss_coin=true
function c60151110.e1costf(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c60151110.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151110.e1costf,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c60151110.e1costf,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c60151110.e1tgf(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c60151110.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151110.e1tgf,tp,LOCATION_HAND,0,1,nil) end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151110.chlimit)
		Duel.RegisterFlagEffect(tp,60151110,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151110.chlimit(e,ep,tp)
	return tp==ep
end
function c60151110.e1opf(c)
	return c:IsAbleToGrave()
end
function c60151110.e1opff(c)
	return c:IsLevelAbove(1)
end
function c60151110.e1opfff(c,e,tp)
	local scg=Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(c60151110.e1opff,c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x9b23) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
			and scg:CheckWithSumGreater(Card.GetLevel,c:GetLevel())
end
function c60151110.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	if Duel.GetFlagEffect(tp,60151110)>0 then
		res=1
	else 
		res=Duel.TossCoin(tp,1) 
	end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151110.e1opf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		local ct=Duel.DiscardHand(tp,c60151110.e1tgf,1,99,REASON_EFFECT+REASON_DISCARD)
		if ct>0 then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end

--2xg

function c60151110.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler() and Duel.GetFlagEffect(tp,60151110)==0
end
function c60151110.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151110.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(60151110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9b23))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,60151110,RESET_PHASE+PHASE_END,0,1)
end