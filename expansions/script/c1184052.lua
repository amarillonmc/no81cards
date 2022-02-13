--饮食艺术·鲜红蛋糕
function c1184052.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,1184052)
	e1:SetCondition(c1184052.con1)
	e1:SetOperation(c1184052.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184052,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,1184052+100)
	e2:SetOperation(c1184052.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184052.cfilter1(c)
	return c:IsSetCard(0x3e12) and c:IsFaceup() and c:IsReleasable()
end
function c1184052.gfilter1(sg)
	return sg:GetClassCount(Card.GetCode)==2
end
function c1184052.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1184052.cfilter1,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(c1184052.gfilter1,2,2,nil)
end
function c1184052.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1184052.cfilter1,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,c1184052.gfilter1,false,2,2,nil)
	Duel.Release(sg,REASON_COST)
end
--
function c1184052.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,0)
	for tc in aux.Next(mg) do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetValue(1000)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
	end
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_2:SetCode(EVENT_PHASE+PHASE_END)
	e2_2:SetCountLimit(1)
	e2_2:SetCondition(c1184052.con2_2)
	e2_2:SetOperation(c1184052.op2_2)
	e2_2:SetReset(EVENT_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_2,tp)
end
function c1184052.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1184052.ofilter2_2(c)
	return c:IsFaceup() and c:GetAttack()==c:GetBaseAttack()
end
function c1184052.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c1185052.ofilter2_2,tp,LOCATION_MZONE,LOCATION_MZONE,0)
	if mg:GetCount()>0 then Duel.SendtoGrave(mg,REASON_RULE) end
end
--