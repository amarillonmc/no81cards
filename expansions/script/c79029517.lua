--刚炼装勇士·银金后宫王
function c79029517.initial_effect(c)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029517,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c79029517.linkcon)
	e1:SetOperation(c79029517.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--draw 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCondition(c79029517.drcon)
	e2:SetTarget(c79029517.drtg)
	e2:SetOperation(c79029517.drop)
	c:RegisterEffect(e2)  
	--change scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetCondition(c79029517.cscon)
	e3:SetValue(c79029517.csval1)
	e3:SetTargetRange(LOCATION_PZONE,0)
	e3:SetTarget(c79029517.cstg1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_RSCALE)
	e3:SetCondition(c79029517.cscon)
	e3:SetValue(c79029517.csval2)
	e3:SetTargetRange(LOCATION_PZONE,0)
	e3:SetTarget(c79029517.cstg2)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c79029517.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e5)
	--to ex
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c79029517.tetg)
	e6:SetOperation(c79029517.teop)
	c:RegisterEffect(e6)
end
function c79029517.sprfilter(c,tp,g,sc)
	return c:IsType(TYPE_PENDULUM)
end
function c79029517.linkcon(e,c)
	return Duel.IsExistingMatchingCard(c79029517.sprfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,4,nil) 
end
function c79029517.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029517.sprfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g1=g:FilterSelect(tp,c79029517.sprfilter,4,4,nil,tp,g,c)
	if Duel.SendtoGrave(g1,REASON_COST+REASON_MATERIAL)~=0 then
	Debug.Message("无上之具汝，银刃炼铜;以吾之身躯，化为最上之后宫吧，上吧，后宫王，为吾之后宫献上心脏。")
end
end
function c79029517.target(e,c)
	return c:IsCode(79029517) or (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_SZONE))
end
function c79029517.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and (c:IsType(TYPE_XYZ) and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_FUSION) and c:IsType(TYPE_PENDULUM)) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c79029517.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029517.cfilter,1,nil,tp)
end
function c79029517.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029517.cscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c79029517.csval1(e,c)
	if c:GetLeftScale()-Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)<0 then return 0 
	else
	return -Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)
end
end
function c79029517.csval2(e,c)
	if c:GetRightScale()+Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)>13 then return 13-c:GetRightScale() 
	else
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)
end
end
function c79029517.cstg1(e,c)
	return c:GetSequence()==0 
end
function c79029517.cstg2(e,c)
	return c:GetSequence()==4 
end
function c79029517.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029517.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) end
end
function c79029517.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_PENDULUM)
	Duel.SendtoExtraP(g,nil,REASON_EFFECT)
end



