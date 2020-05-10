--根源破灭魔虫 凯撒德比西
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000023)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(cm.tdfilter,"td",rsloc.og),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"dish,des","de,dsp",nil,nil,rsop.target({nil,"dish",0,1},{aux.TRUE,"des"}),cm.dishop)
	local e5=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},{1,m+100},"se,th,des","de,dsp",nil,nil,rsop.target({cm.thfilter,"th",LOCATION_DECK},{aux.TRUE,"des"}),cm.thop)
	local e6=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m+100},"sp,des","de,dsp",nil,nil,rsop.target({rscf.spfilter2(Card.IsSetCard,0xaf1),"sp",LOCATION_HAND},{aux.TRUE,"des"}),cm.spop2)
	local e8=rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e9=rsef.RegisterClone(c,e5,"code",EVENT_SUMMON_SUCCESS)
	local e10=rsef.RegisterClone(c,e6,"code",EVENT_SUMMON_SUCCESS)
	--local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+300},"se,th","de,dsp",cm.lcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	--local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,0},{1,m+300},"sp","de,dsp",cm.lcon,nil,rsop.target(rscf.spfilter2(Card.IsSetCard,0xaf1),"sp",LOCATION_HAND),cm.spop2)
end
function cm.tdfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0xaf1) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.dishop(e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		local sg=g:RandomSelect(1-tp,1)
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)>0 and aux.ExceptThisCard(e) then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function cm.lcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf1) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,2,nil,{})>0 and aux.ExceptThisCard(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.spop2(e,tp)
	if rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsSetCard,0xaf1),tp,LOCATION_HAND,0,1,1,nil,{},e,tp)>0 and aux.ExceptThisCard(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end