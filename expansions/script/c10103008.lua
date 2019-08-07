--界限龙王 布内
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103008
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des","tg",LOCATION_MZONE,nil,rscost.reglabel(100),cm.destg,cm.desop,{0,TIMINGS_CHECK_MONSTER })
	local e1=rsef.I(c,{m,1},{1,m+100},"dr,sp","ptg",LOCATION_MZONE+LOCATION_HAND,cm.drcon,rscost.cost(Card.IsReleasable,"res"),cm.drtg,cm.drop)
end
function cm.drcon(e,tp)
	return Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsSetCard,0x337),tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsRace(RACE_DRAGON) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				rssf.SpecialSummon(tc)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function cm.cfilter(c,tp)   
	local eg=c:GetEquipGroup()
	eg:AddCard(c)
	return c:IsRace(RACE_DRAGON) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,eg)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then
			return Duel.CheckReleaseGroupEx(tp,cm.cfilter,1,nil,tp)
		else
			return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		local g=Duel.SelectReleaseGroupEx(tp,cm.cfilter,1,1,nil,tp)
		Duel.Release(g,REASON_COST)
	end
	rsof.SelectHint(tp,"des")
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.desop(e,tp)
	local dg=rsgf.GetTargetGroup()
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end