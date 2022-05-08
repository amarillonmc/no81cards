--终墟秽泥
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015000,"Overuins")
function cm.initial_effect(c)
	--summon proc
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(30015500,0))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(cm.otcon)
	e11:SetOperation(cm.otop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e12)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--Effect 3
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(cm.regop3)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(30015500,2))
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21)
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(30015500,3))
	e22:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCode(EVENT_LEAVE_FIELD)
	e22:SetLabelObject(e20)
	e22:SetCondition(cm.spcon1)
	e22:SetTarget(cm.sptg1)
	e22:SetOperation(cm.spop1)
	c:RegisterEffect(e22)
end
--summon proc
function cm.otconfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) and not c:IsType(TYPE_TOKEN)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) then
		local mg1=Duel.GetMatchingGroup(cm.otconfilter,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
		mg:Merge(mg1)
	end
	return c:IsLevelAbove(5) and minc<=1 and mg:GetCount()>=1
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) then
		local mg1=Duel.GetMatchingGroup(cm.otconfilter,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
		mg:Merge(mg1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=mg:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
end
--Effect 1
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.drmfilter,tp,LOCATION_REMOVED,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.drmfilter,tp,LOCATION_REMOVED,0,nil)
	if mg:GetCount()~=0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=mg:RandomSelect(tp,1)
		local tc=sg:GetFirst() 
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end   
		if tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			if rk.check(tc,"Overuins") then
				if tc:IsSSetable() then
					Duel.SSet(tp,tc)
				else
					Duel.ShuffleHand(tp)
				end
			else
				Duel.ShuffleHand(tp)
			end
			if tc:IsExtraDeckMonster()
				and tc:IsLocation(LOCATION_EXTRA)  then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
--Effect 3
function cm.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabelObject():GetLabel()==1
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
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
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	local ct=e:GetLabelObject()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if sc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		local rg=Group.FromCards(sc,c)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	elseif sc:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		local a=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		Duel.Recover(tp,a*500,REASON_EFFECT)
	end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabelObject():GetLabel()~=1
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
	   if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0 then
			  local a=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
			  Duel.Recover(tp,a*500,REASON_EFFECT)
	   end
	end
end