--Anifriends Debiru-sama, VLiver Incarnate
function c33741113.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x442),aux.FilterBoolFunction(Card.IsFusionSetCard,0x445),true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c33741113.matcheck)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33741113.cftg)
	e2:SetOperation(c33741113.cfop)
	c:RegisterEffect(e2)
end
function c33741113.matcheck(e,c)
	local g=c:GetMaterial()
	local atk,def=0,0
	for tc in aux.Next(g) do atk=atk+tc:GetBaseAttack() def=def+tc:GetBaseDefense() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function c33741113.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=13 end
end
function c33741113.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,13)
	if not g or #g==0 then return end
	Duel.ConfirmDecktop(tp,13)
	if g:GetClassCount(Card.GetCode)~=13 then return end
	local b1=g:FilterCount(Card.IsAbleToHand,nil,tp)>0
	local b2=g:FilterCount(Card.IsAbleToDeck,nil)>0
	local b3=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(33741113,0)},
		{b2,aux.Stringid(33741113,1)},
		{b3,aux.Stringid(33741113,2)})
	if op==3 then return end
	Duel.RevealSelectDeckSequence(true)
	local f=op==1 and Card.IsAbleToHand or Card.IsAbleToDeck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:FilterSelect(tp,f,1,1,nil,tp):GetFirst()
	Duel.RevealSelectDeckSequence(false)
	Duel.DisableShuffleCheck(true)
	if op==1 then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoDeck(tc,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=Duel.GetTurnPlayer()==tp and 1 or 2
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c33741113.atktg)
		e1:SetValue(tc:GetAttack()*(-1))
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetDefense()*(-1))
		Duel.RegisterEffect(e2,tp)
	end
end
function c33741113.atktg(e,c)
	return (c:IsSummonType(SUMMON_TYPE_NORMAL) or c:IsSummonType(SUMMON_TYPE_SPECIAL)) and c:IsSummonPlayer(1-e:GetHandlerPlayer())
end
