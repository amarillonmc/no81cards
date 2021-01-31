--奇机械宇宙人 萨迪斯
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001006)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"dr","ptg",LOCATION_HAND,nil,rscost.cost({Card.IsAbleToGraveAsCost,nil},{cm.tgcfilter,{"tg",cm.tgfun},LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c }),rsop.target(2,"dr"),cm.drop)
	local e2=rsef.I(c,{m,1},{1,m+100},"eq","tg",LOCATION_GRAVE,nil,nil,rstg.target(cm.eqfilter,"eq",LOCATION_MZONE),cm.eqop)
	local e3=rsef.I(c,{m,2},{1,m+200},"sp",nil,LOCATION_SZONE,nil,nil,rsop.target(rscf.spfilter2(cm.spfilter),"sp"),cm.spop)
end
function cm.spfilter(c)
	return c:GetEquipTarget()
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.tgcfilter(c,e,tp)
	return c:IsAbleToGraveAsCost() and ((c:IsRace(RACE_MACHINE) and c:FieldPosCheck()) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function cm.tgfun(g,e,tp)
	g:AddCard(e:GetHandler())
	local ct=Duel.SendtoGrave(g,REASON_COST)
	return Duel.GetOperatedGroup(),ct
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.eqfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqop(e,tp)
	local c,tc=rscf.GetSelf(e),rscf.GetTargetCard(Card.IsFaceup)
	if not c or not tc then return end
	if rsop.Equip(e,c,tc) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetReset(rsreset.est)
		e3:SetRange(LOCATION_SZONE)
		e3:SetOperation(cm.chainop)
		c:RegisterEffect(e3)
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler():GetEquipTarget() then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end