--终墟之始 
local m=30015005
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e01=ors.atkordef(c,200,2000)
	--Effect 2  
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(3)
	e6:SetCondition(cm.con)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--Effect 3 
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
end
c30015005.isoveruins=true
--Effect 1
--Effect 2 
function cm.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.sumf(c) 
	local b1=ors.stf(c) or c:IsLevelAbove(5)
	local b2=c:IsSummonable(true,nil) or c:IsMSetable(true,nil) 
	return b1 and b2
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(cm.drmfilter,tp,LOCATION_REMOVED,0,1,nil) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.drmfilter,tp,LOCATION_REMOVED,0,nil)
	if #mg==0 then return end
	local sg=mg:RandomSelect(tp,1)
	local tcc=sg:GetFirst() 
	if #sg==0 or tcc==nil then return false end  
	if Duel.SendtoHand(tcc,nil,REASON_EFFECT)==0 then return false end
	Duel.ConfirmCards(1-tp,tcc)
	Duel.AdjustAll()
	local sumg=Duel.GetMatchingGroup(cm.sumf,tp,LOCATION_HAND,0,nil)
	local b1=tcc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=#sumg>0
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
		Duel.Remove(tcc,POS_FACEDOWN,REASON_EFFECT)  
	else
		ors.sumop(e,tp,sumg)
	end
end
--Effect 3 
function cm.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp and c:GetPreviousControler()==tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCodeRule()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if ct>0 then
		local mg=sg:Clone()
		mg:RemoveCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,1,0,0)
	end
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end