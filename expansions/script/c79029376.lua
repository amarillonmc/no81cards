--哥伦比亚·先锋干员-豆苗
function c79029376.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c79029376.matfilter1,nil,nil,aux.NonTuner(nil),1,99)   
	aux.EnablePendulumAttribute(c,false)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029376,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029376)
	e1:SetCondition(c79029376.drcon)
	e1:SetTarget(c79029376.drtg)
	e1:SetOperation(c79029376.drop)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029377))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029377))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,09029376)
	e4:SetTarget(c79029376.pentg)
	e4:SetOperation(c79029376.penop)
	c:RegisterEffect(e4) 
	--token 2
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,19029376)
	e8:SetCost(c79029376.spcost)
	e8:SetTarget(c79029376.sptg)
	e8:SetOperation(c79029376.spop)
	c:RegisterEffect(e8)	
end
function c79029376.matfilter1(c)
	return (c:IsSynchroType(TYPE_TUNER) and c:IsSetCard(0xa900)) or (c:IsSynchroType(TYPE_TOKEN))
end
function c79029376.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029376.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029376.drfil(c)
	return c:IsAbleToHand() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029376.drop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("看我们大显身手~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029376,1))
	local g=Duel.GetDecktopGroup(tp,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if g:GetFirst():IsSetCard(0xa900) and Duel.IsExistingMatchingCard(c79029376.drfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029376,0)) then
	Debug.Message("好！这次大家都听我的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029376,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c79029376.drfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	end
end
function c79029376.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsPlayerCanSpecialSummonMonster(tp,79029377,0,0x4011,1000,1000,1,RACE_CYBERSE,ATTRIBUTE_EARTH) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c79029376.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,79029377)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("豆苗作战小队，出动！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029376,3))
	end
end
function c79029376.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c79029376.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029377,0,0x4011,1000,1000,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029376.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("去吧，让他们见识一下我们的实力！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029376,4))
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029377,0,0x4011,1000,1000,1,RACE_CYBERSE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,79029377)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local x=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,79029377)
	if Duel.IsPlayerCanDraw(tp,x) then
	Duel.BreakEffect()
	Duel.Draw(tp,x,REASON_EFFECT)
	end
end










