local m=53754001
local cm=_G["c"..m]
cm.name="异冽之塔 被区别的开始"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.acop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.acop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(cm.handcon)
	c:RegisterEffect(e5)
end
function cm.acop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)==tp or not re:IsActiveType(TYPE_MONSTER) or e:GetHandler():GetFlagEffect(1)<1 then return end
	cm.acop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.ctfilter(c)
	return c:IsCanAddCounter(0x153d,1) and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED+STATUS_LEAVE_CONFIRMED)
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_FLIP) and Duel.IsCanRemoveCounter(tp,1,1,0x153d,c:GetLevel(),REASON_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sfilter(c,lv,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetCounter(tp,1,1,0x153d)>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		g:GetFirst():AddCounter(0x153d,1)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local lvt={}
		for tc in aux.Next(g) do
			local tlv=tc:GetLevel()
			lvt[tlv]=tlv
		end
		local pc=1
		for i=1,13 do if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end end
		lvt[pc]=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
		Duel.RemoveCounter(tp,1,1,0x153d,lv,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp):GetFirst()
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsLocation(LOCATION_MZONE) then
			sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetTarget(function(e,c)
				local le={c:IsHasEffect(EFFECT_CANNOT_SELECT_BATTLE_TARGET)}
				local res=true
				for _,v in pairs(le) do
					if v:GetLabel()~=m then
						local val=v:GetValue()
						if not val or val(v,sc) then
							res=false
							break
						end
					end
				end
				return res
			end)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetLabel(m)
			e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e2:SetLabelObject(e1)
			e2:SetValue(cm.atklimit)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD)
			e3:SetLabelObject(e2)
			e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsContains(sc)end)
			e3:SetOperation(cm.reset)
			Duel.RegisterEffect(e3,tp)
		end
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(-Duel.GetCounter(tp,1,1,0x153d)*400)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function cm.atktg(e,c)
	local tc=e:GetLabelObject()
	local le={c:IsHasEffect(EFFECT_CANNOT_SELECT_BATTLE_TARGET)}
	local res=true
	for _,v in pairs(le) do
		if v:GetLabel()~=m then
			local val=v:GetValue()
			if not val or val(v,tc) then
				res=false
				break
			end
		end
	end
	return res
end
function cm.atklimit(e,c)
	local tc=e:GetLabelObject():GetLabelObject()
	return c==tc
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetLabelObject():Reset()
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
