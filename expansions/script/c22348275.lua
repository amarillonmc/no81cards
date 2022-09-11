--剪 舌 麻 雀 「 大 葛 笼 与 小 葛 笼 」
local m=22348275
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,22348275+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348275.target)
	e1:SetOperation(c22348275.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348275.actcon)
	c:RegisterEffect(e2)

end
function c22348275.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x612)
end
function c22348275.actcon(e)
	return Duel.IsExistingMatchingCard(c22348275.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22348275.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22348276,0,TYPES_TOKEN_MONSTER,2300,2900,9,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end


function c22348275.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22348276,0,TYPES_TOKEN_MONSTER,2300,2900,9,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
	local token=Duel.CreateToken(tp,22348276)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		 -- Move
		local e2=Effect.CreateEffect(token)
		e2:SetDescription(aux.Stringid(22348275,0))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c22348275.seqtg)
		e2:SetOperation(c22348275.seqop)
		token:RegisterEffect(e2)
		 -- atkup
		local e3=Effect.CreateEffect(token)
		e3:SetDescription(aux.Stringid(22348275,2))
		e3:SetCategory(CATEGORY_ATKCHANGE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_BE_BATTLE_TARGET)
		e3:SetCountLimit(1)
		e3:SetCondition(c22348275.atkcon)
		e3:SetOperation(c22348275.atkop)
		token:RegisterEffect(e3)
end
function c22348275.seqfilter(c)
	return c:IsFaceup()
end
function c22348275.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22348275.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348275.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22348275,1))
	Duel.SelectTarget(tp,c22348275.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22348275.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c22348275.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.GetAttacker():IsControler(1-tp)
end
function c22348275.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end

