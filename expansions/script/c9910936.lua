--匪魔军火商 艾尼斯
function c9910936.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),5,2,c9910936.ovfilter,aux.Stringid(9910936,0),2,c9910936.xyzop)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9910936)
	e1:SetCondition(c9910936.reccon)
	e1:SetTarget(c9910936.rectg)
	e1:SetOperation(c9910936.recop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910936,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910949)
	e2:SetCost(c9910936.rmcost)
	e2:SetTarget(c9910936.rmtg)
	e2:SetOperation(c9910936.rmop)
	c:RegisterEffect(e2)
end
function c9910936.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5 and c:IsAbleToGraveAsCost()
end
function c9910936.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3954) and c:IsRace(RACE_FIEND)
end
function c9910936.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9910936)==0
		and Duel.IsExistingMatchingCard(c9910936.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910936.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,9910936,RESET_PHASE+PHASE_END,0,1)
end
function c9910936.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9910936.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c9910936.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c9910936.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910936.tgfilter(c)
	return c:IsSetCard(0x3954) and c:IsAbleToGrave()
end
function c9910936.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local g2=Duel.GetMatchingGroup(c9910936.tgfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return #g1>0 and (g1:IsExists(Card.IsAbleToGrave,1,nil) or #g2>0) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c9910936.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local g2=Duel.GetMatchingGroup(c9910936.tgfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g1)
	if g1:IsExists(Card.IsAbleToGrave,1,nil) then g:Merge(g1:Filter(Card.IsAbleToGrave,nil)) end
	if #g2>0 then g:Merge(g2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=g:Select(tp,1,1,nil)
	if mg:GetCount()>0 then
		Duel.SendtoGrave(mg,REASON_EFFECT)
	end
	Duel.ShuffleExtra(1-tp)
end
