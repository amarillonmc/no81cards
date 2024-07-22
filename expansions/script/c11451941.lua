--“于迷途之中不复迷失”
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0xff,0xff)
	e4:SetTarget(cm.rmtarget)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--check for Jowgen the Spiritualist
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(81674782)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(0xff,0xff)
	e0:SetTarget(aux.TRUE)
	c:RegisterEffect(e0)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_REMOVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(cm.ret)
	c:RegisterEffect(e5)
end
function cm.thfilter(c,sc)
	local code,code2=c:GetCode()
	return c:IsAbleToHand() and c:IsSetCard(0xc976) and sc:GetFlagEffect(m+code+0xffffff)==0 and (not code2 or sc:GetFlagEffect(m+code2+0xffffff)==0)
end
function cm.ret(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,c)
	if eg:IsExists(cm.redfilter,1,nil,e) and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local dc=g:Select(tp,1,1,nil):GetFirst()
		local code,code2=dc:GetCode()
		c:RegisterFlagEffect(m+code+0xffffff,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(code,8))
		if code2 then c:RegisterFlagEffect(m+code2+0xffffff,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(code2,8)) end
		Duel.SendtoHand(dc,nil,REASON_EFFECT)
		g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,c)
		if c:GetFlagEffect(m)>0 and #g==0 then Duel.Readjust() end
	end
end
function cm.redfilter(c,e)
	return c:IsReason(REASON_REDIRECT) and c:GetFlagEffect(m)>0
end
function cm.rmtarget(e,c)
	local res=not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
	if res then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_REMOVE-RESET_LEAVE-RESET_TEMP_REMOVE,0,1) end
	return res
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function cm.filter(c)
	return c:IsLevel(1) and c:IsAbleToRemove()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,5)
	local rg=g:Filter(cm.filter,nil)
	local ct=g:FilterCount(Card.IsLevel,nil,1)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #rg>0 then
		if ct>0 and #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local dg=sg:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			rg:Merge(dg)
		end
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,c)
	if c:GetFlagEffect(m)>0 and #g==0 then Duel.Destroy(c,REASON_RULE) end
end