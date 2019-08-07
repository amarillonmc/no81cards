--量子驱动 聚变核心
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130014
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FTO(c,10130001,{m,0},nil,"rm","de,dsp",LOCATION_SZONE,rsqd.shcon,nil,rsop.target(rsqd.shfilter,nil,LOCATION_MZONE),cm.op)
	local e3=rsef.FTO(c,EVENT_FLIP,{m,1},nil,"rm","de,dsp",LOCATION_SZONE,cm.rmcon,nil,cm.rmtg,cm.rmop)
end
function cm.op(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local rg=g:RandomSelect(tp,1)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	rsqd.ShuffleOp(e,tp)
end
function cm.rmcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
