--《战车》·欧辂昂
local m=60001246
local cm=_G["c"..m]
cm.dfc_front_side=m+1
function cm.initial_effect(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78080961,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.mtcon)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Senya.TransformDFCCard(c)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.TossDice(tp,1)
	if d1=1 or d1=6 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if d1=2 or d1=5 then
		local token=Duel.CreateToken(tp,28053764)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,28053764)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if d1=3 or d1=4 then
		Duel.Recover(tp,1500,REASON_EFFECT)
	end
end