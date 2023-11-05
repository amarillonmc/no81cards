--终墟秽泥
local m=30015000
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--not Special Summon
	local ea=ors.notsp(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,5,3,1)
	--Effect 1
	local e1=ors.atkordef(c,300,3000)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
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
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
end
c30015000.isoveruins=true
---???
---
--Effect 2 
function cm.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.sumf(c) 
	local b1=ors.stf(c) or c:IsLevelAbove(5)
	local b2=c:IsSummonable(true,nil) or c:IsMSetable(true,nil) 
	return b1 and b2
end
function cm.stf(c,tp) 
	return ors.setf(c,tp) and ors.stf(c) 
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
	local sumg=Duel.GetMatchingGroup(cm.sumf,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local setg=Duel.GetMatchingGroup(cm.stf,tp,LOCATION_HAND,0,nil,tp)
	local b1=tcc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=#sumg>0
	local b3=#setg>0
	if b1 or b2 or b3 then
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(m,2)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,3)
			opval[off]=1
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(m,4)
			opval[off]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.Remove(tcc,POS_FACEDOWN,REASON_EFFECT)  
		elseif sel==1 then
			ors.sumop(e,tp,sumg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local ssg=setg:Select(tp,1,1,nil)
			if not ssg:GetFirst():IsType(TYPE_FIELD) and Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then
				Duel.SendtoGrave(ssg,REASON_RULE)
			else
				Duel.SSet(tp,ssg)
			end
		end
	end
end
--Effect 3 
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
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
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end