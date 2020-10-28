--圆盘生物 诺巴
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000122)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td",nil,cm.con,nil,cm.tg,cm.op)   
end
function cm.con(e,tp)
   return Duel.GetCurrentChain()>=2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(tp)
	e:SetLabel(op)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local ctype=e:GetLabel()
	local e1,e2=rsef.FV_CANNOT_DISABLE({c,tp},"dise,act",rsval.cdisneg(cm.filter),nil,nil,rsufo.scon(true),rsreset.pend)
	e1:SetLabel(ctype)
	e2:SetLabel(ctype)
	rsufo.ToDeck(e,true)
end
function cm.filter(e,p,te,tp)
	return tp==p and te:IsActiveType(e:GetLabel())
end
