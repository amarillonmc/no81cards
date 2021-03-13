--决斗者的最后之日
-- BUG CARDS , I HAVE TOLD TO HUANG WU THIS CARD MUST INCLUDE BUGS , HE SAID IT WAS OKAY, JUST DO IT , IGNORE BUGS, SO - EVEN THOUGH I DON'T WANT TO SCRIPT IT.
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006007)
function cm.initial_effect(c)
	local e1 = rsef.SV_ACTIVATE_IMMEDIATELY(c,"hand")
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.cecondition)
	e3:SetOperation(cm.ceoperation)
	c:RegisterEffect(e3)
	local e2 = rsef.SV_ACTIVATE_SPECIAL(c,LOCATION_GRAVE)
end
function cm.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep ~= tp and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,rp,0,rsloc.hog+LOCATION_REMOVED,1,nil)
end
function cm.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local g = Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	local e1 = rsef.FC({c,tp},EVENT_CHAIN_SOLVED,nil,nil,nil,nil,cm.scon,cm.sop)
	e1:SetLabelObject(re)
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave(true)
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function cm.scon(e,tp,eg,ep,ev,re)
	return re == e:GetLabelObject()
end
function cm.sop(e,tp)
	e:Reset()
	rshint.Card(m)
	local c = e:GetHandler()
	local op = Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2)) + 1  
	if op == 1 then
		--bug 1 & 2
		local e1 = rsef.FV_IMMUNE_EFFECT({c,tp},rsval.imoe,nil,{0xff,0},nil,nil,"sa")
		e1:SetOwnerPlayer(tp)
		local e2 = rsef.FV_INDESTRUCTABLE({c,tp},"all",cm.indval,nil,{0xff,0},nil,nil,"sa")
	elseif op == 2 then
		local e1,e2 = rsef.FV_CANNOT_DISABLE({c,tp},"act,dise")
	elseif op == 3 then
		local e3 = rsef.FV_LIMIT_PLAYER({c,tp},"act",cm.val,nil,{0,1})
	end 
end
function cm.indval(e,re,r,rp)
	return rp ~= e:GetOwnerPlayer()
end
function cm.repop(e,tp)
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,rsloc.hog+LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
end
function cm.val(e,re)
	return Duel.GetCurrentChain() > 1
end