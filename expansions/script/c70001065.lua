--幽灵
local m=70001065
local cm=_G["c"..m]
function cm.initial_effect(c)
	--reborn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
	function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))
		and c:IsPreviousPosition(POS_FACEUP)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.SetLP(tp,9000)
	end
end
	function cm.filter(c)
	return c:IsFaceup() and c:IsCode(70001066)
end
	function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp,m)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end