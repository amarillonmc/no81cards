--波动武士·物质波歼击炮
local m=11451440
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
function cm.mzfilter(c)
	return c:IsAbleToGraveAsCost() and (c:GetLevel()>=1) and c:IsRace(RACE_PSYCHO)
end
function cm.fselect(g,lv,c)
	local tp=c:GetControler()
	return g:GetSum(Card.GetLevel)==lv and g:GetCount()>=2 and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local lv=10
	while lv<=g:GetSum(Card.GetLevel) do
		local res=g:CheckSubGroup(cm.fselect,2,#g,lv,c)
		if res then return true end
		lv=lv+10
	end
	return false
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local tp=c:GetControler()
	local list={}
	local lv=10
	while lv<=g:GetSum(Card.GetLevel) do
		if g:CheckSubGroup(cm.fselect,2,#g,lv,c) then table.insert(list,lv) end
		lv=lv+10
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local clv=Duel.AnnounceNumber(tp,table.unpack(list))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,Duel.IsSummonCancelable(),2,#g,clv,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Card.SetMaterial(c,sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=re:IsActiveType(TYPE_MONSTER) and Card.GetFlagEffect(c,m)==0
	local b2=re:IsActiveType(TYPE_SPELL) and Card.GetFlagEffect(c,m-1)==0
	local b3=re:IsActiveType(TYPE_TRAP) and Card.GetFlagEffect(c,m-2)==0
	return rp==1-tp and Duel.IsChainDisablable(ev) and (Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,3,nil) or c:IsAbleToRemove(tp,POS_FACEDOWN)) and (b1 or b2 or b3)
end
function cm.filter2(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,3,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_REMOVED,0,3,3,nil)
				Duel.SendtoDeck(g,tp,2,REASON_EFFECT)
			else
				Duel.BreakEffect()
				if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(c)
					e1:SetCountLimit(1)
					e1:SetOperation(cm.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
			if re:IsActiveType(TYPE_MONSTER) then
				Card.RegisterFlagEffect(c,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			if re:IsActiveType(TYPE_SPELL) then
				Card.RegisterFlagEffect(c,m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			if re:IsActiveType(TYPE_TRAP) then
				Card.RegisterFlagEffect(c,m-2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end