--结晶龙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174042)
function cm.initial_effect(c)
	local e1=rsef.FTF(c,EVENT_CHAINING,{m,0},nil,"atk","de",LOCATION_MZONE,cm.con,nil,nil,cm.op)
	local e2=rsef.STO(c,EVENT_TO_GRAVE,{m,1},nil,"th","tg",cm.thcon,nil,rstg.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not re:GetHandler():IsCode(m)
end
function cm.op(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1,e2=rsef.SV_UPDATE(c,"atk,def",200,nil,rsreset.est)
end
function cm.thcon(e,tp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.thfilter(c)
	return c:GetType()&0x40002==0x40002 and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end