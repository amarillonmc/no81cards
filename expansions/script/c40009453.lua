--超古代龙 盛宴提坦
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009453)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.ToHandFun(c,m)
	local e3=rsef.QO(c,nil,{m,0},nil,"atk,def","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.tgfilter,nil,LOCATION_MZONE,LOCATION_MZONE,1,1,c),cm.limitop)
end
function cm.tgfilter(c,e,tp)
	local rc=e:GetHandler()
	return c:IsFaceup() and c:IsType(rscf.extype) and rc:IsAttackAbove(c:GetAttack()) and rc:IsDefenseAbove(c:GetDefense())
end
function cm.limitop(e,tp)
	local c,tc=rscf.GetFaceUpSelf(e),rscf.GetTargetCard()
	if not c or not tc then return end
	local atk,def = tc:GetAttack(),tc:GetDefense()
	if not c:IsAttackAbove(atk) or not c:IsDefenseAbove(def) then return end
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",{-atk,-def})
	local list = 0
	for _,ctype in pairs(rscf.exlist) do
		list = list | (tc:IsType(ctype) and ctype or 0)
	end
	local e3=rsef.FV_LIMIT_PLAYER({c,tp},"sp",nil,cm.limittg,{1,1},nil,rsreset.pend)
	e3:SetLabel(list)
end
function cm.limittg(e,c)
	return c:IsType(e:GetLabel()) or not c:IsLocation(LOCATION_EXTRA)
end
