--真古代龙 传奇暴龙
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009456)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun(c,m,"res","tg",cm.tg,cm.op)
	local e3=rsad.TributeTFun(c,m,"td","de,tg",rstg.target(cm.tdfilter,"td",LOCATION_GRAVE),cm.tdop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasableByEffect()
end
function cm.resfilter(c,e,tp)
	local rc=e:GetHandler()
	return (c==rc and rc:IsLocation(LOCATION_HAND)) or (c:IsOnField() and rc:IsRace(RACE_DINOSAUR)) and Duel.IsExistingTarget(cm.cfilter,tp,0,LOCATION_ONFIELD,1,c:GetEquipGroup())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=Duel.GetReleaseGroup(tp,true)
	if chkc then return cm.cfilter(chkc) end
	if chk==0 then 
		if e:GetLabel()==100 then 
			e:SetLabel(0)
			return rg:IsExists(cm.resfilter,1,nil,e,tp)
		else
			return Duel.IsExistingTarget(cm.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		local rg=Duel.SelectReleaseGroupEx(tp,cm.resfilter,1,1,nil,e,tp)
		Duel.Release(rg,REASON_COST)
	end
	rshint.Select(tp,HINTMSG_SELF)
	local tg=Duel.SelectTarget(tp,cm.cfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,tg,1,0,0)
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.Release(tc,REASON_EFFECT)
	end
end
function cm.tdfilter(c)
	return not c:IsCode(m) and c:IsRace(RACE_DINOSAUR) and c:IsAbleToDeck()
end
function cm.tdop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end