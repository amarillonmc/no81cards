local m=53752003
local cm=_G["c"..m]
cm.name="冥渡之都 萨尔迦佐"
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.actg)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sccon)
	e3:SetTarget(cm.sctg)
	e3:SetOperation(cm.scop)
	c:RegisterEffect(e3)
end
function cm.tffilter(c,tp)
	return c:GetType()&0x20002==0x20002 and c:GetActivateEffect():IsActivatable(tp)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFacedown() or not c:IsCode(22702055)) and c:IsAbleToDeck()
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not sc then return end
	Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=sc:GetActivateEffect()
	local tep=sc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(sc,73734821,te,0,tp,tp,Duel.GetCurrentChain())
	local dg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD,0,nil)
	if #dg>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsControler(1-tp)
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.scfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSynchroSummonable(nil)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.scfilter,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
