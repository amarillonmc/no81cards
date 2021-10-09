--幽灵骑士Ghost·平成魂
function c9980950.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980950.ffilter,20,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9980950.splimit)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980950.efilter)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980950,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c9980950.target)
	e3:SetOperation(c9980950.operation)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(c9980950.winop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980950.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980950.ffilter(c,fc,sub,mg,sg)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER)
end
function c9980950.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980950,2))
end
function c9980950.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c9980950.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9980950.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c9980950.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980950,3))
end
function c9980950.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x18
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and Duel.GetLP(1-tp)<=2000  then
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	end
end
