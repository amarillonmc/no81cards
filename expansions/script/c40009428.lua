--机械加工 蝎子
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009428)
local m=40009428
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	local e1=rsef.I(c,"dis",nil,"dis,des","tg",LOCATION_HAND,nil,rscost.cost(0,"dish"),rstg.target(cm.disfilter,"dis,des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.disop)
	local e2=rsef.I(c,"th",{1,m},"th",nil,LOCATION_GRAVE,nil,rscost.cost(aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),"res",LOCATION_MZONE),rsop.target(Card.IsAbleToHand,"th"),cm.thop)
end
function cm.thop(e,tp)
	local c = rscf.GetSelf(e)
	if c then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp)
	return cm.Machining(c) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function cm.cfilter2(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp)
end
function cm.disfilter(c,e,tp)
	local cg = c:GetColumnGroup()
	cg:AddCard(c)
	return aux.disfilter1(c) and cg:IsExists(cm.cfilter,1,nil,tp) and cg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.disop(e,tp)
	local tc = rscf.GetTargetCard(aux.disfilter1)
	if not tc then return end
	local e1,e2 = rscf.QuickBuff({e:GetHandler(),tc},"dis,dise")
	if not tc:IsImmuneToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
end