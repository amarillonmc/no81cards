--悖论寄生者·突触
local m=14000034
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,14000021)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,14000021),1,1)
	c:EnableReviveLimit()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(14000021)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(5)
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.stcon)
	e5:SetTarget(cm.sttg)
	e5:SetOperation(cm.stop)
	c:RegisterEffect(e5)
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.cfilter(c,tp)
	return c:IsCode(14000021) and c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_HAND,0,1,c)
end
function cm.cfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==1
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.DiscardHand(tp,cm.cfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO+1
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:IsActiveType(TYPE_QUICKPLAY) or re:GetHandler():IsType(TYPE_QUICKPLAY))
end
function cm.dmfilter(c)
	return cm.TM(c) and c:IsFaceup()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.dmfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	local dam=ct*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(cm.dmfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:IsActiveType(TYPE_TRAP) or re:GetHandler():IsType(TYPE_TRAP))
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(re:GetHandlerPlayer(),0,LOCATION_DECK)>0 end
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.ConfirmDecktop(p,1)
	local g=Duel.GetDecktopGroup(p,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_QUICKPLAY) and tc:IsSSetable() then
		Duel.DisableShuffleCheck()
		Duel.SSet(tp,tc)
		if cm.TM(tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end