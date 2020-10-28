--颓废能力者 懒散的若拉
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000505)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,cm.ovfilter,aux.Stringid(m,0),99,cm.xyzop)
	local e2=rsef.SV_CANNOT_DISABLE(c,"sp")
	local e3=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},1,"rm,sp","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.rmfilter,"rm",rsloc.mg,rsloc.mg,1,1,c),cm.rmop)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function cm.rmop(e,tp)
	local c,tc=rscf.GetFaceUpSelf(e),rscf.GetTargetCard()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) or not rscf.spfilter2()(tc,e,tp) or not c or not c:IsType(TYPE_XYZ) or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	if rssf.SpecialSummon(tc)>0 and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,rsgf.Mix2(tc))
		c:CopyEffect(tc:GetOriginalCodeRule(),rsreset.est)
	end
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(30000500)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*500
end