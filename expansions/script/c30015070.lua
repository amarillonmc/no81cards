--终墟逐退
local m=30015070
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015070.isoveruins=true
--all
--Effect 1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED 
	if chkc then return chkc~=e:GetHandler() and chkc:IsLocation(loc) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,loc,loc,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,loc,loc,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return false end
	local og=Group.CreateGroup()
	if tg==1 then
		local yc=tg:GetFirst()
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.SendtoHand(yc,nil,REASON_EFFECT)
			res=1
		else
			yc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1)) 
			og:AddCard(yc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local hg=tg:Select(tp,1,1,nil)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		res=1
		Duel.AdjustAll()
		local ag=tg-hg
		ag:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1)) 
		og:AddCard(ag:GetFirst())
	end 
	if #og>0 then
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
	end
	if res==0 then return false end
	ors.exrmop(e,tp,res)
end
function cm.thf(c)
	return c:GetFlagEffect(m)>0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:FilterCount(cm.thf,nil)==0 then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.thf,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end