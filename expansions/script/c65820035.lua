--源于黑影 波动
local s,id,o=GetID()
function s.initial_effect(c)
	--正面【表】
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--反面【表】
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCondition(s.condition2)
	e11:SetTarget(s.damtg1)
	e11:SetOperation(s.rmop1)
	c:RegisterEffect(e11)
	--正面【里】
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.condition1)
	e2:SetCost(s.rmcost1)
	e2:SetTarget(s.damtg1)
	e2:SetOperation(s.rmop1)
	c:RegisterEffect(e2)
	--反面【里】
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_ACTIVATE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e21:SetCondition(s.condition3)
	e21:SetCost(s.rmcost1)
	e21:SetTarget(s.damtg)
	e21:SetOperation(s.rmop)
	c:RegisterEffect(e21)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+65820000)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.mecon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

--正面【表】
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)==0
end
--反面【表】
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)>0
end


function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
end
function s.thfilter(c,e)
	return c.effect_lixiaoguo
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc then return end
	--翻面
	Duel.ConfirmCards(1-tp,tc)
	if tc:GetFlagEffect(65820010)==0 then 
		tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
	else
		tc:ResetFlagEffect(65820010)
	end
	Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
	
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end



--正面【里】
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)==0
end
--反面【里】
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)>0
end

function s.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end
function s.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function s.rmop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	--翻面
	Duel.ConfirmCards(1-tp,tc)
	if tc:GetFlagEffect(65820010)==0 then 
		tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
	else
		tc:ResetFlagEffect(65820010)
	end
	Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
	
	if  Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g)
		if #g<=0 then return end
		Duel.BreakEffect()
		local ct=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ct:RegisterEffect(e1)
	end
end


function s.cfilter1(c,tp)
	return c:IsSetCard(0x3a32)
end
function s.mecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end
function s.filter(c)
	return c:IsAbleToDeck()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end