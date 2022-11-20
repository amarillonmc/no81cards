--监视深渊的薪王
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171009)
function cm.initial_effect(c)
	local e1=rsds.ExtraSummonFun(c,m+6,m)
	local e2=rsef.SV_UPDATE(c,"atk",cm.val)
	local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,0},nil,"sp","de,dsp",cm.spcon,rsds.cost2(1),rsop.target(rscf.spfilter2(Card.IsCode,m),"sp",LOCATION_GRAVE,0,1,1,c),cm.spop)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.FilterFaceUp(Card.IsCode,m),e:GetHandlerPlayer(),rsloc.mg,0,e:GetHandler())*1000
end
function cm.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0xa335,0xc335) and (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function cm.spcon(e,tp,eg)
	return eg and eg:IsExists(cm.cfilter,1,nil,tp,rp) 
end
function cm.spop(e,tp)
	local ct,og=rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsCode,m),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,aux.ExceptThisCard(e),{},e,tp)
	if ct>0 then
		og:GetFirst():CompleteProcedure()
	end
end
