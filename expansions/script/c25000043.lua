--原始异生兽 The One
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000043)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,1) 
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"rm,se,th","de,dsp",rscon.sumtype("link"),nil,cm.rmtg,cm.rmop)
	local e2=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"se,th","de,dsp",rssb.lfucon,nil,rsop.target(cm.setfilter,nil,LOCATION_DECK),cm.setop)
end
function cm.setfilter(c)
	return c:IsCode(25000052) and (c:IsAbleToHand() or c:IsSSetable())
end
function cm.setop(e,tp)
	rshint.Select(tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	local b1=tc:IsSSetable()
	local b2=tc:IsAbleToHand()
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then
		Duel.SSet(tp,tc)
	else
		rsop.SendtoHand(tc)
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(rssb.rmfilter,nil)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.thfilter(c)
	return rssb.IsSetM(c) and c:IsAbleToHand()
end
function cm.rmop(e,tp)
	local g=Duel.GetDecktopGroup(tp,3)
	local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,g)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		rsgf.SelectToHand(tg,tp,aux.TRUE,1,1,nil,{})
	end
end