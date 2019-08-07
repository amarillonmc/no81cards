--界限龙神 卡奥斯
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND+LOCATION_GRAVE,cm.spcon,cm.spop)
	local e3=rsef.SV_IMMUNE_EFFECT(c,nil,cm.imcon)
	local e4=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"tg",nil,nil,nil,cm.tdtg,cm.tdop)
end
function cm.tdfilter(c)
	return Duel.IsPlayerCanSendtoGrave(c:GetControler(),c)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.tdop(e,tp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function cm.imcon(e)
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount() and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.spcheck(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x1337)
	return g:CheckSubGroup(cm.spcheck,4,4,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x1337)
	rsof.SelectHint(tp,"res")
	local rg=g:SelectSubGroup(tp,cm.rfilter,false,2,2,tp)
	Duel.Release(rg,REASON_EFFECT)
end