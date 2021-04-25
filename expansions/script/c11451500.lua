--晚上处刑
local m=11451500
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.execution)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end
function cm.execution(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SelectOption(tp,aux.Stringid(m,0))
	Duel.SelectOption(1-tp,aux.Stringid(m,0))
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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(table.unpack(list))
	e1:SetOperation(cm.pigeon)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.pigeonfilter(c,num)
	return c:IsFaceup() and c:IsCode(num)
end
function cm.pigeon(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
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
	Duel.SelectOption(tp,aux.Stringid(m,2))
	Duel.SelectOption(1-tp,aux.Stringid(m,2))
end