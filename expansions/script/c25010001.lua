--光之巨人 复合迪迦
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25010001)
if rsgol then return end
rsgol=cm 
function cm.TigaSummonFun(c,code,spcode1,spcode2,leavecon,sprcon,sprop)
	c:EnableReviveLimit()
	local e1=rscf.SetSummonCondition(c,false,cm.tigasumval(spcode1,spcode2))
	local e2=rsef.QO(c,nil,{m,0},{1,code+700},"sp,te",nil,LOCATION_MZONE,nil,cm.tigaspcost,rsop.target({cm.tigaspfilter(spcode1,spcode2),"sp",LOCATION_EXTRA},{Card.IsAbleToExtra,"te"}),cm.tigaspop(spcode1,spcode2))
	local e3=rsgol.ToExtraEffect(c,leavecon)
	local e4
	if sprcon then
		e4=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,sprcon,sprop)
	end
	return e1,e2,e3,e4
end
function rsgol.ToExtraEffect(c,leavecon)
	local e1=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,1},1,"te",nil,LOCATION_MZONE,leavecon,nil,rsop.target(Card.IsAbleToExtra,"te"),cm.tigateop)
	return e1
end
function cm.tigasumval(code1,code2)
	return function(e,se,sp,st)
		return se and se:GetHandler():IsCode(code1,code2)
	end
end
function cm.tigaspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tigaspfilter(spcode1,spcode2)
	return function(c,e)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCode(spcode1,spcode2)
	end
end
function cm.tigaspop(spcode1,spcode2)
	return function(e,tp)
		local c=aux.ExceptThisCard(e)
		local ct,og,tc=rsop.SelectSpecialSummon(tp,cm.tigaspfilter(spcode1,spcode2),tp,LOCATION_EXTRA,0,1,1,nil,{},e,tp)
		if ct>0 then
			tc:CompleteProcedure()
			if c then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
		end
	end
end
function cm.tigateop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then 
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function rsgol.GaiaSummonFun(c,code,lv,ovfilter,spcode,spcost,disoverlay)
	c:EnableReviveLimit()
	if ovfilter then
		aux.AddXyzProcedure(c,nil,lv,3,ovfilter,aux.Stringid(m,0))
	else
		aux.AddXyzProcedure(c,nil,lv,3)
	end
	if not spcode then return end
	local e1=rsef.STO(c,EVENT_LEAVE_FIELD,{m,0},{1,code+200},"sp","de,dsp",cm.gaiaspcon(disoverlay),spcost,rsop.target(cm.gaiaspfilter(spcode),"sp",LOCATION_EXTRA),cm.gaiaspop(spcode,disoverlay))
	return e1
end
function cm.gaiaspcon(disoverlay)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetHandler()
		return tc:IsPreviousPosition(POS_FACEUP) and (disoverlay or tc:GetOverlayCount()<=0) and (tc:IsReason(REASON_BATTLE) or (tc:IsReason(REASON_EFFECT) and rp~=tp))
	end
end
function cm.gaiaspfilter(spcode)
	return function(c,e,tp)
		return c:IsCode(spcode) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
	end
end
function cm.gaiaspop(spcode,disoverlay)
	return function(e,tp)
		local c=aux.ExceptThisCard(e)
		local ct,og,tc=rsop.SelectSpecialSummon(tp,cm.gaiaspfilter(spcode),tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_XYZ},e,tp)
		if ct>0 then
			tc:CompleteProcedure()
			if not disoverlay and c and c:IsCanOverlay() then
				Duel.Overlay(tc,Group.FromCards(c))
			end
		end
	end
end
------------------------------------
function cm.initial_effect(c)
	rsgol.TigaSummonFun(c,m,m+1,m+2,rscon.turno,cm.sprcon,cm.sprop)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},{1,m},"th","de,dsp",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
end
function cm.sprcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.sprcfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.sprcfilter(c,tp,fc)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.sprcfilter2,tp,LOCATION_HAND,0,1,nil,tp,fc,c)
end
function cm.sprcfilter2(c,tp,fc,c2)
	return c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,c2),fc)>0
end
function cm.sprop(e,tp)
	local c=e:GetHandler()
	rshint.Select(tp,"tg")
	local g1=Duel.SelectMatchingCard(tp,cm.sprcfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	rshint.Select(tp,"tg")
	local g2=Duel.SelectMatchingCard(tp,cm.sprcfilter2,tp,LOCATION_HAND,0,1,1,nil,tp,c,g1:GetFirst())
	Duel.SendtoGrave((g1+g2),REASON_COST)
end
function cm.thfilter(c)
	return c:IsLevelBelow(4) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
end