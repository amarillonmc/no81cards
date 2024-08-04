--绝技回想
local m=13000750
local cm=_G["c"..m]
function c13000750.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter2,cm.fusfilter3,cm.fusfilter4)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,m)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
local ct1=Duel.GetCustomActivityCount(13000750,1-tp,ACTIVITY_CHAIN)
	local ct2=Duel.GetCustomActivityCount(13000750,tp,ACTIVITY_CHAIN)
	return (ct1+ct2)>=4 end)
	e3:SetTarget(cm.adtg2)
	e3:SetOperation(cm.adop2) 
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,m+2000)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetCustomActivityCount(13000750,1-tp,ACTIVITY_CHAIN)
	local ct2=Duel.GetCustomActivityCount(13000750,tp,ACTIVITY_CHAIN)
	return (ct1+ct2)>=3 end)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
 if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(13000750,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return false
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.RegisterFlagEffect(rp,13000750,RESET_PHASE+PHASE_END,0,1)  
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,5,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.drop)
	if Duel.SelectYesNo(tp,aux.Stringid(13000750,0)) then
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			local b2=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden() 
			if b1 and b2 then  
			op=Duel.SelectOption(tp,aux.Stringid(13000750,1),aux.Stringid(13000750,2)) 
			elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(13000750,1)) 
			elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(13000750,2))+1 
			end 
			if op==0 then 
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP) 
			elseif op==1 then  
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
			end 
			Duel.BreakEffect() 
end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h<2 then
	Duel.Draw(tp,2-h,REASON_EFFECT)
end
	if h2<2 then
	Duel.Draw(1-tp,2-h2,REASON_EFFECT)
end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() 
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(cm.efilter)
		tc:RegisterEffect(e1)   
   
end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
 for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) and i>4 then
			return true
		end
	end
	return false
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,5,5,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.Release(g,REASON_RULE)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.spfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.fusfilter1(c)
	return c:IsLevel(1)
end
function cm.fusfilter2(c)
	return c:IsLevel(2)
end
function cm.fusfilter3(c)
	return c:IsLevel(3)
end
function cm.fusfilter4(c)
	return c:IsLevel(4)
end
function cm.fusfilter5(c)
	return c:IsLevel(5)
end