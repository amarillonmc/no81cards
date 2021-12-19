if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=53716001
local cm=_G["c"..m]
cm.name="断片折光 幻想匿国"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.disable)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTarget(cm.attack)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.spcon)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	c:RegisterEffect(e7)
end
function cm.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function cm.costfilter2(c)
	return bit.band(c:GetType(),0x20002)==0x20002 and c:IsSetCard(0x353b) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END and Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_ONFIELD,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,3,nil)
	if chk==0 then return b1 or b2 end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 and not b2 then opt=0
	elseif not b1 and b2 then opt=1 end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
		local cg=g:Filter(Card.IsFacedown,nil)
		if #cg>0 then Duel.ConfirmCards(1-tp,cg) end 
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() and tc:GetSequence()<5 then
			local list={}
			table.insert(list,tc:GetSequence())
			table.insert(list,5)
			e:SetLabel(table.unpack(list))
		else e:SetLabel(5) end
		Duel.Release(g,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
		local cg=g:Filter(Card.IsFacedown,nil)
		if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
		local list={}
		for tc in aux.Next(g) do
			if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() and tc:GetSequence()<5 then table.insert(list,tc:GetSequence()) end
		end
		if #list>0 then
			table.insert(list,5)
			e:SetLabel(table.unpack(list))
		else e:SetLabel(5) end
		Duel.Release(g,REASON_EFFECT)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.offilter(c,list)
	return c:GetSequence()<5 and bit.band(table.unpack(list),c:GetSequence())==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local zg=Duel.GetMatchingGroup(cm.offilter,tp,LOCATION_SZONE,0,nil,list)
	if #zg>0 then
		for tc in aux.Next(zg) do
			table.insert(list,tc:GetSequence()) 
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and #list<6 then
		local filter=0
		for i=1,#list do
			filter=filter|1<<(list[i]+8)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,filter)
		rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8))
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function cm.disable(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.attack(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.filter(c,e,tp)
	if c:IsFaceup() and c:IsSetCard(0x353b) and bit.band(c:GetType(),0x20004)==0x20004 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x353b,TYPES_NORMAL_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),4,c:GetOriginalRace(),c:GetOriginalAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) then
		if c:CheckActivateEffect(true,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		tc:CancelToGrave(false)
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then 
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
