--终墟殊同
local m=30015081
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hcon)
	c:RegisterEffect(e2)
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
	local e13=ors.yongxule(c)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015081.isoveruins=true
--
function cm.ff(c) 
	return c:IsLevelAbove(5) and c:IsFaceup()
end 
function cm.hcon(e)
	local g=Duel.GetMatchingGroup(cm.ff,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g>0
end
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
			if #ocg>0  then
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
