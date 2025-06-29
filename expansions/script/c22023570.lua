--人理之基 罗兰
function c22023570.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c22023570.sumcon)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023570,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22023570)
	e1:SetCondition(c22023570.chcon)
	e1:SetOperation(c22023570.chop)
	c:RegisterEffect(e1)
	--change effect ere
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023570,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023570)
	e2:SetCondition(c22023570.chcon1)
	e2:SetCost(c22023570.erecost)
	e2:SetOperation(c22023570.chop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c22023570.ntcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c22023570.sumcon(e,c,tp,st)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)>=1
end
function c22023570.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) and ep==1-tp
end
function c22023570.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023570.repop)
end
function c22023570.repop(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(1-tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
end
function c22023570.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) and ep==1-tp and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023570.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>2
end
function c22023570.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end