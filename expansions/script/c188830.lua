--怪物·幻翼
function c188830.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188830,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c188830.condition)
	e1:SetTarget(c188830.target)
	e1:SetOperation(c188830.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188830,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_MAIN1)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c188830.condition2)
	e2:SetTarget(c188830.target2)
	e2:SetOperation(c188830.operation2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_PHASE+PHASE_MAIN2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(188830,ACTIVITY_CHAIN,c188830.chainfilter1)
	Duel.AddCustomActivityCounter(188831,ACTIVITY_CHAIN,c188830.chainfilter2)
end
function c188830.chainfilter1(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1
end
function c188830.chainfilter2(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN2
end
function c188830.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c188830.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(12)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c188830.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c188830.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 and Duel.GetCustomActivityCount(188830,1-tp,ACTIVITY_CHAIN)==0) or (ph==PHASE_MAIN2 and Duel.GetCustomActivityCount(188831,1-tp,ACTIVITY_CHAIN)==0) or (ph==PHASE_BATTLE and Duel.GetActivityCount(1-tp,ACTIVITY_ATTACK)==0)
end
function c188830.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c188830.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


