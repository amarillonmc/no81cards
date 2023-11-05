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
	local ge1=ors.allop2(c)
end
c30015095.isoveruins=true
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
	local g=eg:Filter(cm.ddf,nil,tp)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		local res=1
		Duel.BreakEffect()
		ors.exrmop(e,tp,res)		 
	end
end
 
