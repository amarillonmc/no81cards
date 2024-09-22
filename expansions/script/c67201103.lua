--百千抉择的少女 索菲亚
function c67201103.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201103,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	--e1:SetCountLimit(1,67201103)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67201103.drcon)
	e1:SetCost(c67201103.drcost)
	e1:SetTarget(c67201103.drtg)
	e1:SetOperation(c67201103.drop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201103,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	--e2:SetCountLimit(1,67201104)
	e2:SetCondition(c67201103.opcon)
	e2:SetTarget(c67201103.optg)
	e2:SetOperation(c67201103.opop)
	c:RegisterEffect(e2)  
end
function c67201103.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c67201103.drfilter(c,tp)
	return c:IsAbleToGraveAsCost()
end
function c67201103.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c67201103.drfilter,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67201103.drfilter,tp,LOCATION_HAND,0,1,1,c,tp)+c
	Duel.SendtoGrave(g,REASON_COST)
end
function c67201103.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67201103.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--
function c67201103.opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c67201103.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201103)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFlagEffect(tp,67201104)==0
	if chk==0 then return b1 or b2 end
end
function c67201103.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201103)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFlagEffect(tp,67201104)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201103,1),aux.Stringid(67201103,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201103,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201103,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201103,RESET_PHASE+PHASE_END,0,1)
	else
		if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
		Duel.RegisterFlagEffect(tp,67201104,RESET_PHASE+PHASE_END,0,1)
	end
end

