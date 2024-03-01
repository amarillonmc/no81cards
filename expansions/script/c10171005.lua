--灰烬逃脱者 霍克伍德
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171005)
function cm.initial_effect(c)
	local e1,e2=rsds.SearchFun(c,m+10)
	local e3=rsds.ChainingFun(c,m,"dis","tg",rstg.target(aux.disfilter1,"dis",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.disop)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend,"cd")
end 
