--归墟仲裁·清无
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015010,"Overuins")
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
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--Effect 2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
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
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21)
end
--summon proc
function cm.otconfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) 
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetDecktopGroup(tp,6)
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	return c:IsLevelAbove(5) and minc<=1 and (mg:GetCount()>=3
		or (Duel.IsPlayerAffectedByEffect(tp,30015035) 
		and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==6))  
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	local g=Duel.GetDecktopGroup(tp,6)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) 
		and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==6 then
		if Duel.SelectYesNo(tp,aux.Stringid(30015035,3))  then
			c:SetMaterial(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=mg:Select(tp,3,3,nil)
			c:SetMaterial(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=mg:Select(tp,3,3,nil)
		c:SetMaterial(sg)
		Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
	end
end
--Effect 1
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end
--Effect 2
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetCount()>=3 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()==1 
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.remop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	if e:GetLabel()==1 then
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp) --rp==tp or
	if  not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp) --ep~=tp and
	local c=e:GetHandler()
	return  c:GetFlagEffect(m+1)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 and g1:GetCount()>0 then
		g:Merge(g1)
	end
	if g:GetCount()==0 and g1:GetCount()>0 then
		g=g1
	end
	if c:GetFlagEffect(m+1)>=3 and g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleExtra(1-tp)
		Duel.ShuffleHand(1-tp)
		Card.ResetFlagEffect(c,m+1)
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
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
		and (c:IsPreviousLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetLabel()==1) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if e:GetLabelObject():GetLabel()==1 then
		local rc=c:GetReasonCard()
		local re1=c:GetReasonEffect()
		if not rc and re1 then
			local sc=re1:GetHandler()
			if not rc then
				sg:AddCard(sc)
			end
		end 
		if rc then 
			sg:AddCard(rc)
		end
	else
		e:GetLabelObject():SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if sc and sc:IsRelateToEffect(e) 
		and sc:GetOwner()==1-tp 
		and not sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
		and sc:IsAbleToRemove(tp,POS_FACEDOWN) then
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end
	if  c:IsRelateToEffect(e) then
	   if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0 then
		   if e:GetLabelObject():GetLabel()==1 then
			   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,2))
			   Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,2))
		   end
		   if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			   local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,3,nil)
			   if #g>0 then
				   Duel.SendtoHand(g,nil,REASON_EFFECT)
				   Duel.ConfirmCards(1-tp,g)
			   end
		   end 
	   end
	end
end 
   