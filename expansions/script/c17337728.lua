--安娜塔西亚·合辛
function c17337728.initial_effect(c)
	aux.AddMaterialCodeList(c,17337700)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,17337700),c17337728.mfilter,nil,aux.TRUE,0,283)--,c17337728.gcheck

	--synchro level
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_SYNCHRO_LEVEL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(0xff)
	ge0:SetValue(c17337728.synclv)

	--effect grant
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0xff,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3f51))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)

	-- ①：hand limit (Opponent)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c17337728.condition)
	e1:SetTargetRange(0,1) -- 对方
	e1:SetValue(4)
	c:RegisterEffect(e1)
	
	-- ①：hand limit (Self)
	local e1b=e1:Clone()
	e1b:SetTargetRange(1,0) -- 自己
	e1b:SetValue(8)
	c:RegisterEffect(e1b)

	-- ②：draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17337728,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17337728)
	e2:SetCondition(c17337728.drcon1)
	e2:SetCost(c17337728.drcost)
	e2:SetTarget(c17337728.drtg)
	e2:SetOperation(c17337728.drop)
	c:RegisterEffect(e2)

	local e3=e2:Clone()
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c17337728.drcon2)
	c:RegisterEffect(e3)
end

function c17337728.mfilter(c,sc,tc)
	return c:IsTuner(sc) or tc:IsTuner(sc)
end

function c17337728.gcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end

function c17337728.synclv(e,c)
	if c:GetOriginalCode()==17337728 then return 3 else return aux.GetCappedLevel(e:GetHandler()) end
end
function c17337728.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)>Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)
end
function c17337728.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337728.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337728.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337728.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c17337728.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
