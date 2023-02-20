--焰之护符 阳光之惩戒
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009681,"BlazeTalisman")
function cm.initial_effect(c)
	local e1 = rsef.A(c)
	local e2 = rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_SZONE,
		rscon.excard2(cm.cfilter,LOCATION_MZONE),nil,nil,cm.op1)
	local e3 = rsef.I(c,{m,1},{1,m},nil,nil,LOCATION_GRAVE,
		rscon.excard2(cm.cfilter,LOCATION_MZONE),nil,
		rsop.target(cm.tffilter,"dum"),cm.op2)
end
function cm.cfilter(c)
	return c:CheckSetCard("BlazeMaiden") or (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE))
end
function cm.op1(e,tp)
	local c = e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(rsrst.ep)
	e1:SetOperation(cm.chainop)
	Duel.RegisterEffect(e1,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	if cm.cfilter(rc) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.tffilter(c,e,tp)
	return not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function cm.op2(e,tp)
	local c = rscf.GetSelf(e)
	if not c then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.thop(e,tp)
	rsop.SelectExPara("th")
	rsop.SelectOperate("th",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.thfilter(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_RITUAL) and c:IsAbleToHand()
end
cm.Overlay_List = { CATEGORY_TOHAND+CATEGORY_SEARCH,cm.thop }