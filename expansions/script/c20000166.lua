--万念合一者
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=fuef.F(c,1165,EFFECT_SPSUMMON_PROC,"OE","E",nil,SUMMON_TYPE_XYZ,nil,fu_cim.XyzProccon,fu_cim.XyzProctg,aux.XyzLevelFreeOperation(),c)
	local e2=fuef.S(c,nil,EFFECT_SPSUMMON_CONDITION,"OE",nil,aux.xyzlimit,nil,nil,nil,c)
	local e3=fuef.QO(c,0,nil,nil,nil,"M",m,nil,cm.cos3,cm.tg3,cm.op3,c)
	local e4=fuef.QF(c,1,nil,EVENT_MOVE,nil,"M",nil,cm.con4,nil,nil,cm.op4,c)
	local e5=fuef.Creat(c,c,{"TYP",EFFECT_TYPE_XMATERIAL},{"COD",EFFECT_IMMUNE_EFFECT},{"CON",cm.con5},{"VAL",cm.val5})
end
--e3
function cm.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=fugf.GetFilter(tp,"M",{Card.IsSetCard,Card.CheckRemoveOverlayCard},{0xcfd1,{tp,1,REASON_COST}})
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	g=fugf.Get(tp,"MS+MS",Card.IsCanOverlay,nil,e:GetHandler())
	local max=#g>tc:GetOverlayCount() and tc:GetOverlayCount() or #g
	tc=tc:RemoveOverlayCard(tp,1,max,REASON_COST)
	e:SetLabel(tc)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	local c=e:GetHandler()
	local g=fugf.Get(tp,"MS+MS",Card.IsCanOverlay,nil,c)
	if count>#g or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	g=g:Select(tp,count,count,c)
	Duel.HintSelection(g)
	g=g:Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	for tc in aux.Next(g) do
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
	end
	Duel.Overlay(c,g)
end
--e4
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsActivated() and re:IsActiveType(TYPE_XYZ)) then return false end
	return fugf.Filter(eg,{Card.IsReason,Card.IsPreviousLocation},{REASON_COST,LOCATION_OVERLAY},nil,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local count=#fugf.Filter(eg,{Card.IsReason,Card.IsPreviousLocation},{REASON_COST,LOCATION_OVERLAY})
	local g=fugf.GetFilter(tp,"G+G",Card.IsCanOverlay)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsType(TYPE_XYZ) or count>#g then return end
	g=g:Select(tp,count,count,nil)
	Duel.Overlay(c,g)
end
--e5
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ)
end
function cm.val5(e,re,rp)
	if e:GetHandlerPlayer()==re:GetHandlerPlayer() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end