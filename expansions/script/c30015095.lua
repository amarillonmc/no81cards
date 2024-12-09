--终墟打落
local m=30015095
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.ddtg)
	e1:SetOperation(cm.ddop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015095.isoveruins=true
--
function cm.selectop(e,tp,mg)
	if #mg==0 then return false end
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local sg=mg:RandomSelect(tp,1)
		local sgc=sg:GetFirst()
		if sgc and Duel.SendtoHand(sgc,tp,REASON_EFFECT)>0 
			and sgc:IsLocation(LOCATION_HAND)  then
			Duel.ConfirmCards(1-tp,sgc)
		end
	end
end
--Activate
function cm.ddf(c,tp)
	return  c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(LOCATION_HAND)
end
function cm.down(c)
	return  c:IsFacedown() and c:IsLocation(LOCATION_REMOVED)
end
function cm.tf1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.ddf,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local g=eg:Filter(cm.ddf,nil,tp)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		res=1
		local mg=Duel.GetMatchingGroup(cm.tf1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil) 
		if #mg<2 then return false end
		cm.selectop(e,tp,mg)
		Duel.AdjustAll()
		mg=Duel.GetMatchingGroup(cm.tf1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil) 
		cm.selectop(e,1-tp,mg)
	end
	ors.exrmop(e,tp,res)
end
 
