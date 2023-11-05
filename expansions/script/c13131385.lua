--特种野战滑稽兵王
function c13131385.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x3b00),1,1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c13131385.con)
	e1:SetTarget(c13131385.tg)
	e1:SetOperation(c13131385.op)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13131385,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13131385.atkcon)
	e2:SetOperation(c13131385.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c13131385.tg2)
	e4:SetOperation(c13131385.op2)
	c:RegisterEffect(e4)
end
function c13131385.btf(c,ac)
	return c:IsSetCard(13131370) or c==ac
end
function c13131385.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and c13131385.btf(a,e:GetHandler()) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and c13131385.btf(a,e:GetHandler()) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if chk==0 then return tc and tc:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp) end
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c13131385.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c13131385.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c13131385.disf1(c)
	return c:IsFaceup() and c:IsCode(13131370)
end
function c13131385.disf2(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c13131385.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroupCount(c13131385.disf1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,g,1-tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(c13131385.chainlm)
end
function c13131385.chainlm(re,rp,tp)
	return tp==rp 
end
function c13131385.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(c13131385.disf1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local g=Duel.GetMatchingGroup(c13131385.disf2,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<num then return end
	local tg=g:FilterSelect(tp,c13131385.disf1,num,num,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end

function c13131385.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsCode,1,nil,13131370)
end
function c13131385.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,13131370))
	e1:SetValue(100)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,13131370))
	e2:SetValue(100)
	Duel.RegisterEffect(e2,tp)
end