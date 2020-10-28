--唤士的传承者-狎西
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005104,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(Card.IsReleasable,"res",LOCATION_HAND,0,1,1,c),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},{1,m+100},"se,th","de",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
	local e4=rsef.SC(c,EVENT_RELEASE,nil,nil,"cd",nil,cm.regop)
	local e5=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,2},1,"dr",nil,LOCATION_GRAVE+LOCATION_REMOVED,cm.drcon,nil,cm.drtg,cm.drop)
	if cm.switch then return end
	cm.switch = true 
	local ge1=rsef.FC({c,0},EVENT_RELEASE)
	ge1:SetOperation(cm.drctop)
end
function cm.drcon(e,tp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dct=Duel.GetFlagEffect(tp,m)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,Duel.GetFlagEffect(tp,m),REASON_EFFECT)
end
function cm.drctop(e,tp,eg)
	for tc in aux.Next(eg) do
		if rsdc.IsSetM(tc) then
			Duel.RegisterFlagEffect(tc:GetReasonPlayer(),m,rsreset.pend,0,1)
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.thfilter(c)
	return rsdc.IsSetST(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end