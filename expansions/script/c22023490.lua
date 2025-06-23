--人理之诗 牛王反转·迅雷风烈
function c22023490.initial_effect(c)
	aux.AddCodeList(c,22023410)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,22023490+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023490.target)
	e1:SetOperation(c22023490.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023490,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22023490.drcon)
	e2:SetTarget(c22023490.drtg)
	e2:SetOperation(c22023490.drop)
	c:RegisterEffect(e2)
end
c22023490.toss_dice=true
function c22023490.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023490,0xff1,TYPE_NORMAL,2800,0,5,RACE_THUNDER,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	end
end
function c22023490.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 or d==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif d==4 or d==5 or d==6 and c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,22023490,0xff1,TYPE_NORMAL,2800,0,5,RACE_THUNDER,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)

	end
end
function c22023490.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsCode(22023410)
end
function c22023490.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c22023490.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end