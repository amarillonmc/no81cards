--机械加工·驱
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009427)
local m=40009427
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"des","tg",nil,nil,rstg.target(cm.mvfilter,nil,LOCATION_MZONE),cm.act)
end
function cm.mvfilter(c,e,tp)
	return c:IsFaceup() and cm.Machining(c) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function cm.act(e,tp)
	local tc = rscf.GetTargetCard(Card.IsControler,tp)
	if not tc or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local dg = tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.Destroy(dg,REASON_EFFECT)
end