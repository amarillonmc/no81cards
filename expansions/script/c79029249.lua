--罗德岛·辅助干员-稀音
function c79029249.initial_effect(c)
	--pendulum summon
	aux.AddFusionProcFunRep2(c,c79029249.ffilter,3,3,true)
	aux.AddSynchroProcedure(c,nil,c79029249.ffilter,1)
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()  
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029249.splimit1)
	c:RegisterEffect(e2)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79029249)
	e2:SetCondition(c79029249.drcon)
	e2:SetTarget(c79029249.drtg)
	e2:SetOperation(c79029249.drop)
	c:RegisterEffect(e2)
	--DiscardHand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,79029249)
	e3:SetCondition(c79029249.dhcon)
	e3:SetTarget(c79029249.dhtg)
	e3:SetOperation(c79029249.dhop)
	c:RegisterEffect(e3)	
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	c:RegisterEffect(e4)
	--token 2
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE+LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c79029249.thtg)
	e8:SetOperation(c79029249.thop)
	c:RegisterEffect(e8)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(45014450,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c79029249.pencon)
	e6:SetTarget(c79029249.pentg)
	e6:SetOperation(c79029249.penop)
	c:RegisterEffect(e6)
	--time
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029249,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029249.discon)
	e2:SetCost(c79029249.discost)
	e2:SetTarget(c79029249.distg)
	e2:SetOperation(c79029249.disop)
	c:RegisterEffect(e2)
end
function c79029249.ffilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c79029249.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029249.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029249.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local x=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_TOKEN)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,x) and x>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
end
function c79029249.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Debug.Message("“已获取队友数据。”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029249,4))
end
function c79029249.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029249.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local x=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_TOKEN)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and x>0 end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_HAND,1,x,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,tp,LOCATION_HAND)
end
function c79029249.dhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Debug.Message("“已获取子数据。”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029249,5))
end
function c79029249.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029250,0,0x4011,1500,1500,4,RACE_CYBERSE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029249.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029250,0,0x4011,1500,1500,4,RACE_CYBERSE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,79029250)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("“开始摄像。”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029249,0))
end
function c79029249.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029249.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029249.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029249.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c79029249.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029249.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("“请为稀音小姐安排吊床，谢谢。”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029249,1))
	end
end
function c79029249.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79029249.disfil(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function c79029249.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029249.disfil,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029249.disfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c79029249.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029249.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029249,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetLabelObject(re)
	e1:SetTarget(re:GetTarget())
	e1:SetOperation(re:GetOperation())
	c:RegisterEffect(e1)
	Duel.ChangeChainOperation(ev,c79029249.repop)
	Debug.Message("“延时——”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029249,2))
end
function c79029249.repop(e,tp,eg,ep,ev,re,r,rp)
end



