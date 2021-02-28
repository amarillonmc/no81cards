--真古代龙 流电三角龙
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009455)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun(c,m,"atk,def","tg",cm.tg,cm.op,true)
	local e3=rsad.TributeTFun(c,m,"dr","de,ptg",rsop.target(1,"dr"),cm.drop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function cm.resfilter(c,e,tp)
	local rc=e:GetHandler()
	return (c==rc and rc:IsLocation(LOCATION_HAND)) or (c:IsOnField() and rc:IsRace(RACE_DINOSAUR)) and Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=Duel.GetReleaseGroup(tp,true)
	if chkc then return cm.cfilter(chkc) end
	if chk==0 then 
		if e:GetLabel()==100 then 
			e:SetLabel(0)
			return rg:IsExists(cm.resfilter,1,nil,e,tp)
		else
			return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		local rg=Duel.SelectReleaseGroupEx(tp,cm.resfilter,1,1,nil,e,tp)
		Duel.Release(rg,REASON_COST)
	end
	rshint.Select(tp,HINTMSG_SELF)
	local tg=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op(e,tp)
	local tc,c=rscf.GetTargetCard(Card.IsFaceup),e:GetHandler()
	if not tc then return end
	local e1,e2=rsef.SV_UPDATE({c,tc},"atk,def",{c:GetAttack(),c:GetDefense()},nil,rsreset.est_pend,"cd")
end
function cm.drop(e,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end