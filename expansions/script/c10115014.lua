--炼金生命体 聚合雾状体
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115014
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.QO(c,nil,{m,0},{1,m},nil,"tg",LOCATION_MZONE,nil,nil,rstg.target(Card.IsFaceup,nil,LOCATION_MZONE,LOCATION_MZONE),cm.limitop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},nil,"tg",LOCATION_HAND+LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res"),rstg.target(cm.pfilter,nil,LOCATION_MZONE,0,1,1,c),cm.pop)
	--local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},nil,"de,dsp",rsab.descon,nil,rstg.target(rsop.list(cm.setfilter,nil,LOCATION_GRAVE)),cm.setop)
end
function cm.pfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3330) 
end
function cm.pop(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	local e1=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imoe,nil,rsreset.est_pend)
end
function cm.limitop(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	tc:RegisterFlagEffect(m,rsreset.est_pend,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	local e1,e2=rsef.SV_LIMIT({c,tc},"ress,resns",nil,nil,rsreset.est_pend,"cd")
	local e3,e4,e5,e6=rsef.SV_CANNOT_BE_MATERIAL({c,tc},"fus,syn,xyz,link",nil,nil,rsreset.est_pend,"cd")
end
function cm.setfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x3331) and c:IsType(TYPE_SPELL)
end
function cm.setop(e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct<=0 then return end
	rsof.SelectHint(tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,1,ct,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SSet(tp,sg)
		Duel.ConfirmCards(1-tp,sg)
	end
end
