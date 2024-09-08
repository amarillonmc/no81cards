--终墟殊同
local m=30015081
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.rstcon)
	e12:SetOperation(cm.rstop)
	c:RegisterEffect(e12)
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
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(cm.tthcon)
	e32:SetTarget(cm.tthtg)
	e32:SetOperation(cm.tthop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(cm.tthcon2)
	c:RegisterEffect(e33)
end
c30015081.isoveruins=true
--Effect 1
function cm.tof(c)
	return  c:IsAbleToDeck() and c:IsFaceup()
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.tof,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return #mg>0 
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.tof,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #mg>0 then
		Duel.Hint(HINT_CARD,0,m)
		local ct=Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if ct==0 then return false end
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
--Effect 2
function cm.dtf(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.sef(c,tp)
	return ors.stf(c) and ors.setf(c,tp)
end
function cm.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.dtf,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return #mg>0 
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.dtf,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #mg>0 then
		Duel.Hint(HINT_CARD,0,m)
		local g1=mg:Select(tp,1,#mg,nil) 
		if #g1>0 then
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ocg=og:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA) 
			if #ocg>0 and Duel.Recover(tp,#g1*100,REASON_EFFECT)>0 then
				Duel.AdjustAll()
				local g2=Duel.GetMatchingGroup(cm.sef,tp,LOCATION_DECK,0,nil,tp)
				local dct=math.floor(#ocg/5) 
				if dct>0 and #g2>0 then
					local sg=g2:RandomSelect(tp,dct)
					for tc in aux.Next(sg) do 
						if tc==nil then return false end
						if tc:IsType(TYPE_FIELD) then 
							Duel.SSet(tp,tc)
						else
							if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
								Duel.SSet(tp,tc)
							else
								Duel.SendtoGrave(tc,REASON_RULE)
							end
						end
					end
				end
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
--negop--
function cm.tthcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	local dc=de:GetHandler()
	if de and de~=nil and dc:IsControler(1-tp) then
		e:SetLabelObject(dc)
	end
	return rp==tp and de and de~=nil and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.tthcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function cm.tthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(30015500)
	local dc=e:GetLabelObject()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	if dc and dc~=nil then
		Duel.SetTargetCard(dc)
		sg:AddCard(dc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.tthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc and dc~=nil then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end