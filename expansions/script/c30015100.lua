--归墟仲裁·沌涡
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015100,"Overuins")
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
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21)
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(30015500,3))
	e22:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e22:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e22:SetCode(EVENT_LEAVE_FIELD)
	e22:SetLabelObject(e20)
	e22:SetCondition(cm.spcon1)
	e22:SetTarget(cm.sptg1)
	e22:SetOperation(cm.spop1)
	c:RegisterEffect(e22)
end
--summon proc
function cm.otconfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) 
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) then
		local mg1=Duel.GetMatchingGroup(cm.otconfilter,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
		mg:Merge(mg1)
	end
	return c:IsLevelAbove(7) and minc<=1 and mg:GetCount()>=3
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) then
		local mg1=Duel.GetMatchingGroup(cm.otconfilter,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
		mg:Merge(mg1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=mg:Select(tp,3,3,nil)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
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
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,1))
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetCode(EFFECT_IMMUNE_EFFECT)
	--e1:SetValue(cm.efilter)
	--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.reccon)
	e2:SetOperation(cm.negop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--local e11=Effect.CreateEffect(c)
	--e11:SetDescription(aux.Stringid(m,2))
	--e11:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE+CATEGORY_TODECK)
	--e11:SetType(EFFECT_TYPE_QUICK_O)
	--e11:SetCode(EVENT_FREE_CHAIN)
	--e11:SetRange(LOCATION_MZONE)
	--e11:SetCountLimit(1)
	--e11:SetTarget(cm.rntg)
	--e11:SetOperation(cm.rnop)
	--e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	--c:RegisterEffect(e11)
	if e:GetLabel()==1 then
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.efilter(e,te)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return not (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) and te:GetOwner()~=e:GetOwner()
end
function cm.drmfilter1(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end

function cm.fauprm(c)
	return  c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.drmfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g=Duel.GetMatchingGroup(cm.fauprm,tp,0,LOCATION_ONFIELD,nil,tp)
	return re:IsActiveType(TYPE_MONSTER) and #mg~=0 and #g~=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.drmfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g=Duel.GetMatchingGroup(cm.fauprm,tp,0,LOCATION_ONFIELD,nil,tp)
	if #g==0 or #mg==0 or not Duel.IsPlayerCanRemove(tp) then return end
	if #g~=0 and #mg~=0 then
		Duel.Hint(HINT_CARD,0,m)
		local g1=g:RandomSelect(tp,1)
		local tc=g1:GetFirst()
		Duel.HintSelection(g1)
		local g2=mg:RandomSelect(tp,1)
		local ct=g2:GetFirst()
		if ct then
			Duel.SendtoGrave(ct,REASON_EFFECT+REASON_RETURN)
			if ct:IsLocation(LOCATION_GRAVE) then
				local rtype=bit.band(tc:GetType(),0x7)
				if ct:IsType(rtype) then
					local rg=Group.FromCards(tc,ct)
					Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)  
				else
					Duel.Remove(ct,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end  
	end
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.drmfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g=Duel.GetMatchingGroup(cm.fauprm,tp,0,LOCATION_ONFIELD,nil,tp)
	return #mg~=0 and #g~=0
end
function cm.todeck(c,tp)
	return  c:IsAbleToDeck() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,POS_FACEDOWN)
end
function cm.rntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.todeck,tp,LOCATION_REMOVED,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(cm.todeck,tp,LOCATION_REMOVED,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_REMOVED)
end
function cm.rnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.todeck,tp,LOCATION_REMOVED,0,nil,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE,0,nil,tp,POS_FACEDOWN)
	if g:GetCount()>0 and mg:GetCount()>0 then
		local g1=mg:Select(tp,1,mg:GetCount(),nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if  og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				local sg=g:FilterSelect(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),1,og:GetCount(),nil,tp,POS_FACEDOWN)
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				Duel.ShuffleDeck(tp)
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
		   if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,c) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			   local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,3,nil)
			   if #g>0 then
				   Duel.SendtoHand(g,nil,REASON_EFFECT)
				   Duel.ConfirmCards(1-tp,g)
				   if g:GetFirst():IsLocation(LOCATION_HAND) then
				   local og=Duel.GetOperatedGroup()
				   if og:GetCount()~=0 then
					   local sg=og:FilterSelect(tp,cm.sum,1,1,nil)
					   local tc=sg:GetFirst()
					   if not (tc:IsSummonable(true,nil)
						   and tc:IsMSetable(true,nil))
						   and tc:IsAbleToRemove(tp,POS_FACEDOWN) then
						   Duel.Remove(og,POS_FACEDOWN,REASON_EFFECT)
					   else
						   if tc:IsSummonable(true,nil) 
							   and (not tc:IsMSetable(true,nil)
							   or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
							   Duel.Summon(tp,tc,true,nil)   
						   else
							   Duel.MSet(tp,tc,true,nil)
						   end   
					   end   
				   end
			   end
		   end
	   end
	end
end
function cm.thfilter(c)
	return c:IsFacedown() and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)) and c:IsAbleToHand()
end
function cm.sum(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.val(e,re,ev,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end