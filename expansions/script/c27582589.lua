--逆王的法阵
local m=27582589
local cm=_G["c"..m]
	function cm.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.extg)
	e1:SetOperation(cm.exop)
	c:RegisterEffect(e1)
	--AnnounceCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.etarget)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	  --summonlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND)
	e5:SetTargetRange(1,0)
	e5:SetTarget(cm.splimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e6)	
end
	function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,nil,m)
	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())
end
	function cm.actop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={0x7381,OPCODE_ISSETCARD}
	table.insert(getmetatable(e:GetHandler()).announce_filter,TYPE_MONSTER)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISTYPE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local tk=Duel.CreateToken(tp,ac)
	Card.ReplaceEffect(tk,27582589,nil)
	local op_1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	local op_2=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
	if op_1==0 then
		if op_2==0 then
			Duel.SendtoHand(tk,tp,nil)
		end
		if op_2==1 then
			Duel.SendtoDeck(tk,tp,2,nil)
		end
	end
	if op_1==1 then
		if op_2==0 then
			Duel.SendtoHand(tk,1-tp,nil)
		end
		if op_2==1 then
			Duel.SendtoDeck(tk,1-tp,2,nil)
		end
	end
end
	function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
		for _,te in ipairs(ce) do
			ct=math.max(ct,te:GetValue())
		end
		return ct<2000
	end
end
	function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2000)
	Duel.RegisterEffect(e1,tp)
end
	function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x7381)
end
	function cm.etarget(e,c)
	return not c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsSetCard(0x7381)
end
	function cm.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_MONSTER+TYPE_TRAP)
end