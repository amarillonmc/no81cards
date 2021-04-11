--千变前面·奈亚拉提托普
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114511)
function cm.initial_effect(c)
	local e1 = rsef.I(c,"tg",{1,m},"tg,sp",nil,LOCATION_HAND,nil,rscost.cost(Card.IsAbleToGraveAsCost,"tg"),rsop.target(cm.tgfilter,"tg,sp",LOCATION_DECK),cm.tgop)
	local e2 = rsef.STO_Flip(c,"tg",{1,m+100},"tg","de",nil,rscost.reglabel(100),cm.tg,cm.op)
end
function cm.tgfilter(c)
	if not c:IsSetCard(0xca4) or not c:IsType(TYPE_MONSTER) then return false end
	local g = Duel.GetFieldGroup(c:GetControler(),LOCATION_MZONE,0)
	local b1 = c:IsAbleToGrave()
	local b2 = #g>0 and g:FilterCount(Card.IsFacedown,nil) == #g 
	return b1 or b2
end
function cm.tgop(e,tp)
	local g,tc = rsop.SelectSolve(HINTMSG_SELF,tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc then return end
	local g = Duel.GetFieldGroup(tc:GetControler(),LOCATION_MZONE,0)
	local b1 = tc:IsAbleToGrave()
	local b2 = #g>0 and g:FilterCount(Card.IsFacedown,nil) == #g 
	local op = rshint.SelectOption(tp,b1,"tg",b2,"sp")
	if op == 1 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.cfilter(c,code)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_FUSION) and not c:IsCode(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk == 0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode())
	end
	e:SetLabel(0)
	local g = rsop.SelectSolve("cf",tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,{},c:GetCode())
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.op(e,tp)
	local c,tc = rscf.GetFaceUpSelf(e),rscf.GetTargetCard()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and c and not c:IsCode(tc:GetCode()) then
		local e1 = rsef.SV_Card(c,"code",tc:GetCode(),nil,nil,nil,rsrst.std)
	end
end