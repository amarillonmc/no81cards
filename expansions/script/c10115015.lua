--炼金生命体 聚合熔融体
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115015
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	local e1=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg,des","dsp,dcal",LOCATION_MZONE,cm.negcon,nil,cm.negtg,cm.negop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},"sp","tg,de,dsp",rsab.descon,nil,rstg.target3(cm.fun,{cm.spfilter,"sp",LOCATION_GRAVE,0,1,1,c},rsop.list(cm.spfilter,"sp",true)),cm.spop)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsRace,1,c,c:GetRace())
			and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and rp==1-tp
end
function cm.checkchain(ev,tp,e)
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if p~=tp then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if e then
				if Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
					dg:AddCard(tc)
				end
			else
				if tc:IsRelateToEffect(te) then
					dg:AddCard(tc)
				end
			end
		end
	end
	return ng,dg
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng,dg=cm.checkchain(ev,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,#ng,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local ng,dg=cm.checkchain(ev,tp,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.zonecheck(c,tp)
	local zonelist={0x1,0x2,0x4,0x8,0x10,0x20,0x40}
	local sumzone=0
	local g=Group.CreateGroup()
	for _,zone in pairs(zonelist) do 
		local ct=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,c,zone) or Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
		if ct>0 and Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,0x7f-zone)>0 then
			sumzone=sumzone|zone
		end
	end
	return sumzone
end
function cm.fun(e,tp)
	local c=e:GetHandler()
	return cm.zonecheck(c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function cm.spop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if not c or not tc then return end
	local sumzone=cm.zonecheck(c,tp)
	if sumzone==0 then return end
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP,sumzone)
	rssf.SpecialSummonStep(tc)  
	Duel.SpecialSummonComplete()
end