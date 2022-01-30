--アブソルーター・ドラゴン
function c10105502.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10105502.sprcon)
	c:RegisterEffect(e1)
--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105502,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,10105502)
	e2:SetCost(c10105502.drcost)
	e2:SetTarget(c10105502.drtg)
	e2:SetOperation(c10105502.drop)
	c:RegisterEffect(e2)
end
function c10105502.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ccd)
end
function c10105502.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10105502.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10105502.drcfilter(c)
	return c:IsSetCard(0x7ccd) and c:IsAbleToGraveAsCost()
end
function c10105502.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c10105502.drcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c10105502.drcfilter,1,1,REASON_COST,nil)
end
function c10105502.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10105502.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end