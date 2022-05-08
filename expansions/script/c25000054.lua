local m=25000054
local cm=_G["c"..m]
cm.name="巨大邪神 十四"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	if not cm.Destroyer_Fourteen then
		cm.Destroyer_Fourteen=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsLevelAbove(1) then Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+10000,RESET_PHASE+PHASE_END,0,1) end
	end
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsLevel,nil,0)
	return rg:CheckSubGroup(aux.mzctcheck,4,4,tp)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsLevel,nil,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheck,true,4,4,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLevelAbove(1) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
		local flag=Duel.GetFlagEffectLabel(tp,m)
		local b1=Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(1-tp,m+10000)>0 and bit.band(flag,0x1)==0
		local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(1-tp,m+10000)>1 and bit.band(flag,0x2)==0
		local b3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFlagEffect(1-tp,m+10000)>2 and bit.band(flag,0x4)==0
		local b4=Duel.GetFlagEffect(1-tp,m+10000)>3 and bit.band(flag,0x8)==0
		return b1 or b2 or b3 or b4 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
	local flag=Duel.GetFlagEffectLabel(tp,m)
	local off=1
	local ops={}
	local opval={}
	local b1=Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(1-tp,m+10000)>0 and bit.band(flag,0x1)==0
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(1-tp,m+10000)>1 and bit.band(flag,0x2)==0
	local b3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFlagEffect(1-tp,m+10000)>2 and bit.band(flag,0x4)==0
	local b4=Duel.GetFlagEffect(1-tp,m+10000)>3 and bit.band(flag,0x8)==0
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
		Duel.SetFlagEffectLabel(tp,m,flag|0x1)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
		Duel.SetFlagEffectLabel(tp,m,flag|0x2)
	elseif sel==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
		if g:GetCount()==0 then return end
		local ac=1
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		if #g==2 then ac=Duel.AnnounceNumber(tp,1,2) end
		if #g>2 then ac=Duel.AnnounceNumber(tp,1,2,3) end
		local sg=g:RandomSelect(1-tp,ac)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,m,flag|0x4)
	else
		Duel.Damage(1-tp,4000,REASON_EFFECT)
		Duel.SetFlagEffectLabel(tp,m,flag|0x8)
	end
end
