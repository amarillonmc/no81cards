--地上毁灭序曲
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000077)
function cm.initial_effect(c)   
	aux.AddCodeList(c,25000073)
	local e1=rsef.SV_ACTIVATE_IMMEDIATELY(c,"hand",cm.con)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},'se,th,tg',nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e3=rsef.FV_LIMIT_PLAYER(c,"act",cm.val,nil,{1,1})
	local e4=rsef.STO(c,EVENT_TO_GRAVE,{m,1},nil,"th","de,dsp",nil,nil,rsop.target(cm.thfilter2,"th",LOCATION_GRAVE),cm.thop)
end
function cm.con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.thfilter(c)
	return c:IsCode(25000073) and c:IsAbleToHand()
end
function cm.act(e,tp)
	if not rscf.GetSelf(e) then return end
	if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
		if #g>0 and rsop.SelectYesNo(tp,{m,0}) then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function cm.val(e,re)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_GRAVE) and rc:IsType(TYPE_SPELL+TYPE_TRAP) and rc:IsControler(1-e:GetHandlerPlayer())
end 
function cm.thfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil,{})
end