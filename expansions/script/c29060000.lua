--无限零·始之冠
function c29060000.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),9,9)
	c:EnableReviveLimit()
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29060000.wincon)
	e1:SetOperation(c29060000.winop)
	c:RegisterEffect(e1)	
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c29060000.sumsuc)
	c:RegisterEffect(e2)
end
function c29060000.wincon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterialCount()>0 and e:GetHandler():GetMaterial():GetClassCount(Card.GetCode)==e:GetHandler():GetMaterialCount()
end
function c29060000.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CREATORGOD=0x1
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_ZERO)
end
function c29060000.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end






