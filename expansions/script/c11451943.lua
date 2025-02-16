--联军盛宴
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) local _,res=pcall(loadfile,"expansions/script/c"..c:GetOriginalCode()..".lua") return res end,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(function(c) return c:GetOriginalCode()//100000 end)//7
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(function(c) local _,res=pcall(loadfile,"expansions/script/c"..c:GetOriginalCode()..".lua") return res end,p,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(function(c) return c:GetOriginalCode()//100000 end)//7
	if ct>0 then Duel.Draw(p,ct,REASON_EFFECT) end
end