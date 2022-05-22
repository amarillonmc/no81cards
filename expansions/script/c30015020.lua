--归墟仲裁·屠破
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015020,"Overuins")
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
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.togcon)
	e2:SetTarget(cm.togtg)
	e2:SetOperation(cm.togop)
	c:RegisterEffect(e2)
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EVENT_PHASE+PHASE_END)
	e13:SetCountLimit(1)
	e13:SetCondition(cm.togcon1)
	e13:SetTarget(cm.togtg)
	e13:SetOperation(cm.togop)
	c:RegisterEffect(e13)
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
	return c:IsLevelAbove(5) and minc<=1 and mg:GetCount()>=2
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(cm.otconfilter,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) then
		local mg1=Duel.GetMatchingGroup(cm.otconfilter,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
		mg:Merge(mg1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=mg:Select(tp,2,2,nil)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
end
--Effect 1
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
end
--Effect 2
function cm.togcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.togcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
		and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local g1=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_GRAVE,nil,tp)
	if chk==0 then return g:GetCount()+g1:GetCount()>=4 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.togop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local g1=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_GRAVE,nil,tp)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local attk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()+g1:GetCount()>=4 and #g2~=0  then
		local a=g1:GetCount()
		local b=g:GetCount()
		if #g1~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local mg1=g1:Select(tp,0,a,nil)
			local c=4-mg1:GetCount()
			if #mg1>=5 then c=0 end 
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local mg=g:Select(tp,c,b,nil)
			if mg:GetCount()+mg1:GetCount()>=4 then
				mg:Merge(mg1)
				if Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mg:GetCount()-3,nil)
					if g3:GetCount()>0 then
						Duel.HintSelection(g3)
						Duel.SendtoGrave(g3,REASON_RULE)
						local up=Duel.GetOperatedGroup()
						if #up~=0 and #attk~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
							local tc=attk:GetFirst()
							while tc do
								local e1=Effect.CreateEffect(e:GetHandler())
								e1:SetType(EFFECT_TYPE_SINGLE)
								e1:SetCode(EFFECT_UPDATE_ATTACK)
								e1:SetValue(up:GetCount()*300)
								e1:SetReset(RESET_EVENT+RESETS_STANDARD)
								tc:RegisterEffect(e1)
								tc=attk:GetNext()
							end
						end
					end
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local mg=g:Select(tp,4,b,nil)
			if #mg>0  then
				if Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mg:GetCount()-3,nil)
					if g3:GetCount()>0 then
						Duel.HintSelection(g3)
						Duel.SendtoGrave(g3,REASON_RULE)
						local up=Duel.GetOperatedGroup()
						if #up~=0 and #attk~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
							local tc=attk:GetFirst()
							while tc do
								local e1=Effect.CreateEffect(e:GetHandler())
								e1:SetType(EFFECT_TYPE_SINGLE)
								e1:SetCode(EFFECT_UPDATE_ATTACK)
								e1:SetValue(up:GetCount()*300)
								e1:SetReset(RESET_EVENT+RESETS_STANDARD)
								tc:RegisterEffect(e1)
								tc=attk:GetNext()
							end
						end
					end
				end
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
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
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
		   if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp,POS_FACEDOWN) then
			   local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEDOWN)
			   if g:GetCount()==0 then return end
			   Duel.ConfirmCards(tp,g) 
			   local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
			   local tc=sg:GetFirst()
			   Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			   Duel.ShuffleHand(1-tp)
		   end 
	   end
	end
end 
   