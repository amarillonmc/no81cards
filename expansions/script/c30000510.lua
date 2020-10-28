--悠闲的假日
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000510)
function cm.initial_effect(c)
	local e2=rsef.I(c,{m,1},1,"dr","ptg",LOCATION_SZONE,nil,cm.drcost,rsop.target(1,"dr"),cm.drop)
	local e3=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,2},1,nil,"tg",LOCATION_SZONE,nil,nil,rstg.target(cm.tgfilter,nil,LOCATION_MZONE),cm.endop)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.act)
	c:RegisterEffect(e1)	
end
function cm.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(30000500,30000505) and Duel.IsExistingMatchingCard(cm.matfilter,tp,rsloc.mg,rsloc.mg,1,nil,c:IsCode(30000505))
end 
function cm.matfilter(c,check)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and (not check or c:IsCanOverlay())
end
function cm.endop(e,tp)
	local c,tc=rscf.GetSelf(e),rscf.GetTargetCard()
	if not c or not tc then return end
	rsop.SelectSolve({m,3},tp,aux.NecroValleyFilter(cm.matfilter),tp,rsloc.mg,rsloc.mg,1,1,nil,{cm.fun,tc},c:IsCode(30000505))
end
function cm.fun(g,tc)
	local rc=g:GetFirst()
	if tc:IsCode(30000505) then
		Duel.Overlay(tc,rsgf.Mix2(rc))
	else
		tc:CopyEffect(rc:GetOriginalCodeRule(),rsreset.est)
	end
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x92b) and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local c=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.drop(e,tp)
	if not rscf.GetSelf(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,rsloc.hdg)
end
function cm.spfilter(c,e,tp)
	return rscf.spfilter2(Card.IsCode,30000500)(c,e,tp) 
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hdg,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if rssf.SpecialSummon(sg)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
