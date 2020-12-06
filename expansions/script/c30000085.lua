--终焉邪魂 堕天的使徒 萨利丝
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000085)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"dr","ptg",LOCATION_HAND,nil,cm.drcost,cm.drtg,cm.drop)
	local e2=rsef.STO(c,EVENT_REMOVE,{m,1},nil,"lv","de,dsp",nil,nil,rsop.target(cm.lvfilter,nil,LOCATION_MZONE),cm.lvop)
end
function cm.lvfilter(c)
	return c:IsLevelAbove(1) and c:IsFaceup()
end
function cm.lvop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,cm.lvfun,e)
end
function cm.lvfun(g,e)
	local tp=e:GetHandlerPlayer()
	local c,tc=e:GetHandler(),g:GetFirst()
	rshint.Select(tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,8)
	local clv=tc:GetLevel()
	local op=rsop.SelectOption(tp,true,{m,2},clv>lv,{m,3})
	local lv2=op==1 and lv or -lv
	rscf.QuickBuff({c,tc},"lv+",lv2)
	return true
end
function cm.cfilter(c,e)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_DARK)
end 
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c) end
	rshint.Select(tp,"rm")
	local rg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,c)
	rg:AddCard(c)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local dct=ct==0 and 3 or 1
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dct)
	if ct==0 then
		e:SetLabel(100)
	else
		e:SetLabel(0)
	end 
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and e:GetLabel()==100 then
		Duel.BreakEffect()
		Duel.Draw(p,2,REASON_EFFECT)
	end
end
