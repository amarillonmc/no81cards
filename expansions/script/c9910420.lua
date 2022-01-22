--赛博空间的佣兵
function c9910420.initial_effect(c)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c9910420.splimit)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910420)
	e2:SetCost(c9910420.tgcost)
	e2:SetTarget(c9910420.tgtg)
	e2:SetOperation(c9910420.tgop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910421)
	e3:SetCondition(c9910420.descon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9910420.destg)
	e3:SetOperation(c9910420.desop)
	c:RegisterEffect(e3)
end
function c9910420.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x6950)
end
function c9910420.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910420.tgfilter(c)
	return c:IsSetCard(0x6950) and c:IsAbleToGrave()
end
function c9910420.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910420.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c9910420.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910420.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910420,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
end
function c9910420.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_FUSION)
		and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsControler(tp)
end
function c9910420.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910420.cfilter,1,nil,tp)
end
function c9910420.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910420.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
