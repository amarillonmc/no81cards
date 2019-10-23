--卡通电子终结龙
function c40008522.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,83629030,3,false,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	 --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c40008522.sprcon)
	e3:SetOperation(c40008522.sprop)
	c:RegisterEffect(e3)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c40008522.regcon)
	e5:SetOperation(c40008522.atklimit)
	c:RegisterEffect(e5)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008522.dircon)
	c:RegisterEffect(e4)   
end
function c40008522.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c40008522.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008522.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008522.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008522.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008522.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008522.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008522.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x62) and c:IsType(TYPE_MONSTER) and (not sg or sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c40008522.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c40008522.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp,c)
end
function c40008522.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x62) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c40008522.sprfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,c,tp,fc,c)
end
function c40008522.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0x62) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and c:IsFusionCode(mc:GetFusionCode())
		and Duel.IsExistingMatchingCard(c40008522.sprfilter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,c,tp,fc,mc,c)
end
function c40008522.sprfilter3(c,tp,fc,mc1,mc2)
	local g=Group.FromCards(c,mc1,mc2)
	return c:IsFusionSetCard(0x62) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and c:IsFusionCode(mc1:GetFusionCode()) and c:IsFusionCode(mc2:GetFusionCode())
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c40008522.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c40008522.sprfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c40008522.sprfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c40008522.sprfilter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,nil,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end







