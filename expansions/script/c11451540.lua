--绯焰悲空
--21.06.21
local m=11451540
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451537,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.actcon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=4*Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=4*Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	if ct>0 then Duel.DiscardDeck(tp,ct,REASON_EFFECT) end
	--summon proc
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(cm.otcon)
	e2:SetOperation(cm.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e3,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(#eg)
	return true
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,1-tp,REASON_COST)
end
function cm.setfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ct=math.max(1,e:GetLabel())
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft=math.min(ct,ft)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,1,ft,nil)
	if #g==0 then return end
	local fid=e:GetHandler():GetFieldID()
	if Duel.SSet(tp,g)==0 then return end
	g:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	e1:SetLabelObject(g)
	e1:SetLabel(fid)
	e1:SetCondition(cm.rmcon)
	e1:SetOperation(cm.rmop)
	Duel.RegisterEffect(e1,tp)
end
function cm.rmfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end