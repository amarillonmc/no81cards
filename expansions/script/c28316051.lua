--闪耀的紫焰光 幽谷雾子
function c28316051.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316051)
	e1:SetCost(c28316051.cost)
	e1:SetTarget(c28316051.sptg)
	e1:SetOperation(c28316051.spop)
	c:RegisterEffect(e1)
	--to grave or remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316051,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316051)
	e2:SetCondition(c28316051.tgcon)
	e2:SetTarget(c28316051.tgtg)
	e2:SetOperation(c28316051.tgop)
	c:RegisterEffect(e2)
end
function c28316051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLPCost(tp,1500)
	local b2=Duel.GetLP(tp)<=3000 and Duel.CheckLPCost(tp,500)
	local b3=Duel.IsPlayerAffectedByEffect(tp,28368431)
	if chk==0 then return b1 or b2 end
	if b3 or not b1 or (b2 and Duel.SelectYesNo(tp,aux.Stringid(28316051,3))) then
		Duel.PayLPCost(tp,500)
	else
		Duel.PayLPCost(tp,1500)
	end
end
function c28316051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28316051.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316051.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:IsControler(tp)
end
function c28316051.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not eg:IsContains(e:GetHandler()) and eg:IsExists(c28316051.cfilter,1,nil,tp)
end
function c28316051.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28316051.refilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToRemove()
end
function c28316051.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28316051.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local b1=Duel.IsExistingMatchingCard(c28316051.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28316051.refilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.GetLP(tp)<=3000 and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(28316051,2)) then
		Duel.BreakEffect()
		if b1 and (not b2 or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c28316051.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,c28316051.refilter,tp,LOCATION_DECK,0,1,2,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
