--白笛 不动如山之奥森
local m=33330017
local cm=_G["c"..m]
cm.mat={33330004}   --素 材 要 求
cm.counter=0x1556   --指 示 物
function cm.initial_effect(c)
	c:EnableReviveLimit() 
	--Xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x556),4,2)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(cm.rmcon)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
end
cm.card_code_list=cm.mat
--Remove
function cm.rmcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,cm.mat[1]) and aux.bdocon(e)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if tc then Duel.Remove(tc,POS_FACEUP,REASON_RULE) end
end
--Destroy Replace
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x556) and c:IsControler(tp)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and Duel.IsCanRemoveCounter(tp,1,0,cm.counter,1,REASON_COST) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,cm.counter,1,REASON_COST)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end