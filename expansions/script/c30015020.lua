--归墟仲裁·屠破
local m=30015020
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,8,4,2)
	--Effect 1
	local e1=ors.atkordef(c,100,3500)
	--Effect 2 
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetCondition(ors.adsumcon)
	e13:SetTarget(cm.togtg)
	e13:SetOperation(cm.togop)
	c:RegisterEffect(e13)
	--Effect 3 
	local e7=ors.monsterle(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015020.isoveruins=true
--Effect 2 
function cm.ff(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	local gap=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>=3 and #gap>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,3,#gap+2,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(#sg-2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,gap,#sg-2,0,0)
end
function cm.togop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ec=e:GetHandler()
	local gap=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if ct==0 then return end
	if #gap>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=gap:Select(tp,ct,ct,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then return false end
		local rct=Duel.GetOperatedGroup():GetCount()
		local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ff),0,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
		if #rg>=rct and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local mg=rg:Select(tp,rct,rct,nil)
			Duel.Hint(HINT_CARD,0,m) 
			Duel.BreakEffect()
			Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end