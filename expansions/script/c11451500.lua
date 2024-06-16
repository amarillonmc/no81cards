--晚上处刑
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCondition(cm.condition)
	--e1:SetCost(cm.cost)
	e1:SetOperation(cm.execution)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCost(cm.hand)
	c:RegisterEffect(e2)
end
cm.toss_coin=true
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSSetable,e:GetHandlerPlayer(),LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_SZONE)>1 end
	cm.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if Duel.SSet(tp,tc,tp,false)>0 then
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,3))
			local fid=c:GetFieldID()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			if tc:IsType(TYPE_QUICKPLAY) then e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN) end
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCondition(cm.actcon)
			e1:SetDescription(aux.Stringid(m,5))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetCode(EVENT_CHAINING)
			e2:SetLabel(fid)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.rscon)
			e2:SetOperation(cm.rsop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e4:SetCode(EVENT_CHAINING)
			e4:SetLabel(fid)
			e4:SetLabelObject(tc)
			e4:SetCondition(cm.sscon)
			e4:SetOperation(cm.ssop)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
			local e5=e4:Clone()
			e5:SetCode(EVENT_CHAIN_NEGATED)
			e5:SetLabelObject(e4)
			e5:SetOperation(cm.ssop2)
			Duel.RegisterEffect(e5,tp)
			e:SetLabelObject(e4)
		end
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(m+1)==0 then return end
	if c:GetFlagEffect(m)==0 then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
	else
		c:SetFlagEffectLabel(m,c:GetFlagEffectLabel(m)+1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetLabel(ev)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(cm.resetop)
	Duel.RegisterEffect(e2,tp)
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(m+1)==0 then return end
	if ev==e:GetLabel() then
		if flag and flag==1 then
			c:ResetFlagEffect(m)
		elseif flag and flag>1 then
			c:SetFlagEffectLabel(m,flag-1)
		end
	end
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	local flag=re:GetHandler():GetFlagEffectLabel(m+1)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and flag and flag==e:GetLabel()
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0xffffff)
end
function cm.ssop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function cm.actcon(e)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m)
	return flag and flag>=7
end
function cm.execution(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SelectOption(tp,aux.Stringid(m,0))
	local hd=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ac=Duel.AnnounceCard(tp)
	local list={ac}
	getmetatable(c).announce_filter={ac,OPCODE_ISCODE,OPCODE_NOT}
	while #list<hd and Duel.SelectYesNo(tp,aux.Stringid(m,1)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
		table.insert(list,ac)
		table.insert(getmetatable(c).announce_filter,ac)
		table.insert(getmetatable(c).announce_filter,OPCODE_ISCODE)
		table.insert(getmetatable(c).announce_filter,OPCODE_NOT)
		table.insert(getmetatable(c).announce_filter,OPCODE_AND)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(table.unpack(list))
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetOperation(cm.pigeon)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.pigeonfilter(c,num)
	return c:IsFaceup() and c:IsCode(num)
end
function cm.pigeon(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local e4=e:GetLabelObject()
	if aux.GetValueType(e4)=="Effect" and e4:GetLabel()==0xffffff then Duel.SelectOption(tp,aux.Stringid(m,2)) return end
	local list={e:GetLabel()}
	local dg=Group.CreateGroup()
	for i=1,#list do
		Duel.Hint(HINT_CARD,0,list[i])
		if Duel.TossCoin(tp,1)==1 then
			Debug.Message("wd卡，炸了")
			local g=Duel.GetMatchingGroup(cm.pigeonfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,list[i])
			dg:Merge(g)
		else
			Debug.Message("算了，先放")
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
	e:Reset()
end