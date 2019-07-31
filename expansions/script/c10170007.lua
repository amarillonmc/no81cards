--虹色·星闪猫
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170007
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	local e1=rssp.LinkCopyFun(c)
	local e2=rssp.ChangeOperationFun2(c,m,false,cm.con,cm.op)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa333)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.actfilter(c)
	if not c:IsSetCard(0xa333) or not (c:GetType()&0x10002==0x10002 or c:GetType()&0x4==0x4) then return false end
	return c:CheckActivateEffect(false,true,false)~=nil
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"tg")
	local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end