local m=53796054
local cm=_G["c"..m]
cm.name="家访"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) end
	local t={}
	local i=1
	for i=1,math.min(3,Duel.GetMatchingGroupCount(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)) do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if num>#g then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:RandomSelect(tp,num)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetLabel(num)
	e2:SetLabelObject(sg)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(cm.costop)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e3,tp)
	Duel.ShuffleHand(1-tp)
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_HAND) and not c:IsPublic()
end
function cm.filter(c,sg,tp,rp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_HAND) and rp~=tp and sg:IsContains(c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsExists(cm.cfilter,1,nil) then
		e:Reset()
		return false
	else return eg:FilterCount(cm.filter,nil,e:GetLabelObject(),tp,rp)>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=eg:Filter(cm.filter,nil,sg,tp,rp)
	sg:Sub(g)
	if #sg==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetLabel(e:GetLabel())
		e1:SetOperation(cm.drop)
		if Duel.GetCurrentChain()==0 and Duel.GetFlagEffect(0,m)==0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
		else
			if Duel.GetCurrentChain()==0 and Duel.GetFlagEffect(0,m)>0 then
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				local e2=e1:Clone()
				e2:SetCode(EVENT_SUMMON_NEGATED)
				e2:SetLabelObject(e1)
				Duel.RegisterEffect(e2,tp)
				local e3=e1:Clone()
				e3:SetCode(EVENT_CUSTOM+m)
				e3:SetLabelObject(e2)
				e3:SetOperation(cm.reset)
				Duel.RegisterEffect(e3,tp)
			else e1:SetCode(EVENT_CHAIN_END) end
			Duel.RegisterEffect(e1,tp)
		end
		e:Reset()
	else
		sg:KeepAlive()
		e:SetLabelObject(sg)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	if e:GetCode()==EVENT_SUMMON_SUCCESS then Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev) end
	if e:GetCode()==EVENT_SUMMON_NEGATED then if e:GetLabelObject() then e:GetLabelObject():Reset() end end
	e:Reset()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,0)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
