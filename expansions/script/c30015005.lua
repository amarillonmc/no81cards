--终墟始 
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015005,"Overuins")
function cm.initial_effect(c)
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
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(3)
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
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.ctfilter(c)
	return not c:IsType(TYPE_TOKEN) 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:Filter(cm.ctfilter,nil)
	local tc=ct:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end 
--Effect 1
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.drmfilter,tp,LOCATION_REMOVED,0,1,nil) 
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
			if tc:IsType(TYPE_MONSTER)  then
				if not (tc:IsSummonable(true,nil)
					and tc:IsMSetable(true,nil))
					and tc:IsAbleToRemove(tp,POS_FACEDOWN) then
					Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
				else
					if tc:IsSummonable(true,nil) 
						and (not tc:IsMSetable(true,nil)
						or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
						Duel.Summon(tp,tc,true,nil)   
					else
						Duel.MSet(tp,tc,true,nil)
					end   
				end
			else
				if tc:IsAbleToRemove(tp,POS_FACEDOWN) then
					Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
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
	return  c:IsPreviousLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetLabel()==1 
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
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	local ct=Duel.GetFlagEffect(tp,m)
	if c:IsLocation(LOCATION_HAND) or not c:IsAbleToHand() then return end
	if sc and sc:IsRelateToEffect(e) 
		and sc:GetOwner()==1-tp 
		and e:GetLabelObject():GetLabel()==1
		and not sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
		and sc:IsAbleToRemove(tp,POS_FACEDOWN) then
		Debug.Message(1200) 
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end
	if  c:IsRelateToEffect(e) then
	   if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		   if e:GetLabelObject():GetLabel()==1 then
			   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,2))
			   Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,2))
		   end
		   if ct>0 
			   and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,ct,nil)
			   if g:GetCount()>0 then
				   Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			   end
		   end
	   end
	end
end 