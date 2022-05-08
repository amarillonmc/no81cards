if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
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
function cm.fselect(g,ft,res)
	local sel=g:IsExists(function(c)return c:IsLocation(LOCATION_SZONE) and c:GetSequence()~=5 and c:IsFaceup()end,1,nil) or ft>0
	return sel and ((res and #g~=2 and (g:IsExists(function(c)return bit.band(c:GetType(),0x20002)==0x20002 and c:IsSetCard(0x353b)end,1,nil) or #g==3)) or (not res and #g==3))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local costg=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local res=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
	if chk==0 then return costg:CheckSubGroup(cm.fselect,1,3,ft,res) and not e:GetHandler():IsForbidden() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=costg:SelectSubGroup(tp,cm.fselect,false,1,3,ft,res)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	local list={}
	for tc in aux.Next(g) do if tc:IsLocation(LOCATION_SZONE) and tc:GetSequence()~=5 then table.insert(list,tc:GetSequence()) end end
	if #list>0 then
		table.insert(list,5)
		e:SetLabel(table.unpack(list))
	else e:SetLabel(5) end
	Duel.Release(g,REASON_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local c=e:GetHandler()
	local chkl=0
	for cl=0,4 do if Duel.CheckLocation(tp,LOCATION_SZONE,cl) and not SNNM.IsInTable(cl,list) then chkl=1 end end
	if not c:IsRelateToEffect(e) or chkl==0 then return end
	local filter=0
	for i=1,#list do filter=filter|1<<(list[i]+8) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,filter)
	if flag and rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8)) then
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
