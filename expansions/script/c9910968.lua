--尽露的永夏 三谷良一
require("expansions/script/c9910950")
function c9910968.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910968+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910968.spcon)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,9910979)
	e3:SetCondition(c9910968.drcon)
	e3:SetTarget(c9910968.drtg)
	e3:SetOperation(c9910968.drop)
	c:RegisterEffect(e3)
end
function c9910968.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5954)
end
function c9910968.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910968.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9910968.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c9910968.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910968.drop(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	res=Duel.Draw(p,d,REASON_EFFECT)>0
	QutryYx.ExtraEffectSelect(e,tp,res)
end
