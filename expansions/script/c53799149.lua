if not require and Duel.LoadScript then
	function require(str)
		local name=str
		for word in string.gmatch(str,"%w+") do
			name=word
		end
		Duel.LoadScript(name..".lua")
		return true
	end
end
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local m=53799149
local cm=_G["c"..m]
cm.name="离你而去"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,tp)
	end
end
function cm.filter(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(cm.filter,p,LOCATION_SZONE,0,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do Duel.RegisterFlagEffect(p,m,0,0,0,tc:GetSequence()) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()~=tp
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.damfilter(c,g)
	return g:IsContains(c) and c:GetBaseAttack()>0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.damfilter,tp,0,LOCATION_MZONE,nil,c:GetColumnGroup())
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and #g>0 then
		Duel.BreakEffect()
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Damage(1-tp,sg:GetFirst():GetBaseAttack(),REASON_EFFECT)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_SZONE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_GRAVE)
	if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	e1:SetCondition(cm.tfcon)
	e1:SetTarget(cm.tftg)
	e1:SetOperation(cm.tfop)
	e:GetHandler():RegisterEffect(e1)
end
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()~=e:GetLabel()
end
function cm.tffilter(c,list)
	return c:GetSequence()<5 and bit.band(table.unpack(list),c:GetSequence())==0
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag={Duel.GetFlagEffectLabel(tp,m)}
	table.sort(flag)
	local list={flag[1]}
	if #flag>1 then for i=2,#flag do if flag[i]>flag[i-1] then table.insert(list,flag[i]) end end end
	local fg=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_SZONE,0,nil,list)
	if chk==0 then return #list+#fg<5 end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag={Duel.GetFlagEffectLabel(tp,m)}
	table.sort(flag)
	local list={flag[1]}
	if #flag>1 then for i=2,#flag do if flag[i]>flag[i-1] then table.insert(list,flag[i]) end end end
	local fg=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_SZONE,0,nil,list)
	if #list+#fg>4 or not c:IsRelateToEffect(e) then return end
	table.insert(list,5)
	if #fg>0 then for tc in aux.Next(fg) do table.insert(list,tc:GetSequence()) end end
	local filter=0
	for i=1,#list do filter=filter|1<<(list[i]+8) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=Duel.SelectField(tp,1,LOCATION_SZONE,0,filter)
	Scl.Place2Field(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8))
end
