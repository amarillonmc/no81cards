--灭亡迅雷·刺客-渡渡鸟·改
function c9981227.initial_effect(c)
   c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9981227.sprcon)
	e1:SetOperation(c9981227.sprop)
	c:RegisterEffect(e1)
 --draw(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981227,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9981227.target)
	e2:SetOperation(c9981227.operation)
	c:RegisterEffect(e2)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9981227.atkval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9981227)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9981227.target2)
	e1:SetOperation(c9981227.activate2)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981227.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981227.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981227,0))
end
function c9981227.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbc9) and c:IsAbleToRemoveAsCost()
end
function c9981227.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981227.sprfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c9981227.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981227.sprfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9981227.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xbc9) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9981227,1)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c9981227.atkval(e,c)
	return math.floor(Duel.GetLP(1-e:GetHandlerPlayer())/2)
end
function c9981227.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9981227.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981227.filter,tp,LOCATION_ONFIELD,0,1,c) end
	local sg=Duel.GetMatchingGroup(c9981227.filter,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c9981227.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9981227.filter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981227,2))
end