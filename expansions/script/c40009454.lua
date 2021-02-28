--真古代龙 长柄枪林龙
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009454)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun2(c,m,nil,nil,rsop.target(cm.cfilter,nil,LOCATION_DECK),cm.op)
	local e3=rsad.TributeTFun(c,m,nil,"de",nil,cm.atkop)
end
function cm.cfilter(c,e,tp)
	local rc=e:GetHandler()
	return c:IsAttackBelow(rc:GetAttack()) and c:IsDefenseBelow(rc:GetDefense()) and c:IsRace(RACE_DINOSAUR)
end
function cm.gcheck(g,e)
	local c=e:GetHandler()
	local atk,def=c:GetAttack(),c:GetDefense()
	return g:GetSum(Card.GetAttack)<=atk and g:GetSum(Card.GetDefense)<=def
end
function cm.op(e,tp)
	--local c=rscf.GetFaceUpSelf(e)
	--if not c then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil,e)
	if #g<=0 then return end
	rshint.Select(tp,HINTMSG_SELF)
	local rg=g:SelectSubGroup(tp,cm.gcheck,false,1,3,e)
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleDeck(tp)
	for tc in aux.Next(rg) do
		Duel.MoveSequence(tc,0)
	end
	Duel.SortDecktop(tp,tp,#rg)
end
function cm.atkop(e,tp)
	local e1,e2=rsef.FV_UPDATE({e:GetHandler(),tp},"atk,def",1000,aux.TargetBoolFunction(Card.IsRace,RACE_DINOSAUR),{LOCATION_MZONE,0},nil,rsreset.pend)
end