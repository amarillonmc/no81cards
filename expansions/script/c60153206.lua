--器灵·幽月暗影刃
function c60153206.initial_effect(c)

	--1效果
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153206,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c60153206.e1con)
	e1:SetOperation(c60153206.e1pop)
	c:RegisterEffect(e1)
	
	--2效果
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60153206,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetTarget(c60153206.e4tg)
	e4:SetOperation(c60153206.e4op)
	c:RegisterEffect(e4)
	
	--3效果
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60153206,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c60153206.e3tg)
	e3:SetOperation(c60153206.e3op)
	c:RegisterEffect(e3)
end

--1效果

function c60153206.e1con(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.CheckLPCost(tp,1000)
end
function c60153206.e1pop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c60153206.lim)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e7:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e7)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60153206,0))
end
function c60153206.lim(e,c,st)
	return st==SUMMON_TYPE_FUSION
end

--2效果

function c60153206.e4tgf(c)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or c:IsLocation(LOCATION_REMOVED)
end
function c60153206.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60153206.e4tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(c60153206.e4tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,g,1,0,0)
end
function c60153206.e4op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c60153206.e4tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_GRAVE) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				if tc:IsLocation(LOCATION_REMOVED) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
			if tc:IsLocation(LOCATION_REMOVED) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 then
				if tc:IsLocation(LOCATION_GRAVE) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
			tc=g:GetNext()
		end
	end
end

--3效果

function c60153206.e3tgf(c)
	return c:IsAbleToHand()
end
function c60153206.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 and Duel.IsExistingMatchingCard(c60153206.e3tgf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c60153206.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg2=g2:Select(tp,1,1,nil)
		dg1:Merge(dg2)
		if dg1:GetCount()==2 then
			Duel.HintSelection(dg1)
			if Duel.Remove(dg1,POS_FACEDOWN,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local g=Duel.SelectMatchingCard(tp,c60153206.e3tgf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end