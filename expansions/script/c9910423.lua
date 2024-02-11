--赛博空间蓝图
function c9910423.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910423)
	e2:SetCost(c9910423.spcost)
	e2:SetTarget(c9910423.sptg)
	e2:SetOperation(c9910423.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,9910424)
	e3:SetCondition(c9910423.drcon)
	e3:SetTarget(c9910423.drtg)
	e3:SetOperation(c9910423.drop)
	c:RegisterEffect(e3)
end
function c9910423.rfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv>0 and c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9910423.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,lv+3,e,tp)
end
function c9910423.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_HAND) or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT))
end
function c9910423.spfilter2(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910423.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910423.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910423.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel()+3)
	Duel.Release(g,REASON_COST)
end
function c9910423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,0)
end
function c9910423.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910423.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if g:GetFirst():IsPreviousLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9910423.cfilter(c,tp,rp)
	return rp==1-tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp and c:IsSetCard(0x6950)
end
function c9910423.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910423.cfilter,1,nil,tp,rp)
end
function c9910423.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910423.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
