--天地大同
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174060)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"rm,dr","cd,cn",nil,nil,cm.tg,cm.op)
end
function cm.cfilter(c,lv)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) and c:IsLevel(lv) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.checkrm(tp)
	for lv=1,12 do 
		if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,lv) then return false end
	end
	return true
end
function cm.checkdct(tp)
	local dctlist={}
	for p=0,1 do
		local dct=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
		for i=1,dct do
			if Duel.IsPlayerCanDraw(p,i) then
				dctlist[p]=i
			end
		end
	end
	return dctlist[0]>0 or dctlist[1]>0,dctlist[tp],dctlist[1-tp]
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res1=cm.checkrm(tp)
	local res2,dcttp,dctop=cm.checkdct(tp)
	if chk==0 then return res1 and res2 and Duel.GetLP(1-tp)~=1 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,12,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,math.min(dcttp,dctop))
end
function cm.op(e,tp)
	local res1=cm.checkrm(tp)
	local res2,dcttp,dctop=cm.checkdct(tp)
	if not res1 then return end
	local rg=Group.CreateGroup()
	for lv=1,12 do 
		rshint.Select(tp,"rm")
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,lv)
		rg:Merge(g)
	end
	Duel.ConfirmCards(1-tp,rg)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) and Duel.GetLP(1-tp)~=1 then
		Duel.SetLP(1-tp,1)
		if dcttp>0 then
			Duel.Draw(tp,dcttp,REASON_EFFECT)
		end
		if dctop>0 then
			Duel.Draw(1-tp,dctop,REASON_EFFECT)
		end
	end
end