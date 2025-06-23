--人理之基 玛塔·哈丽
function c22023500.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023500,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,22023500)
	e1:SetCondition(c22023500.condition)
	e1:SetTarget(c22023500.target)
	e1:SetOperation(c22023500.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023500,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22023500.drcon)
	e3:SetTarget(c22023500.drtg)
	e3:SetOperation(c22023500.drop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCountLimit(1,22023501)
	e4:SetCondition(c22023500.efcon)
	e4:SetOperation(c22023500.efop)
	c:RegisterEffect(e4)
	--draw ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023500,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c22023500.drcon1)
	e5:SetCost(c22023500.erecost)
	e5:SetTarget(c22023500.drtg)
	e5:SetOperation(c22023500.drop)
	c:RegisterEffect(e5)
end
function c22023500.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c22023500.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22023500.cfilter,1,nil,1-tp)
end
function c22023500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023500.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c22023500.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c22023500.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c22023500.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22023500.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ or r==REASON_FUSION or r==REASON_SYNCHRO or r==REASON_LINK 
end
function c22023500.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22023500,2))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c22023500.cttg2)
	e1:SetOperation(c22023500.ctop2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c22023500.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c22023500.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end
function c22023500.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023500.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end