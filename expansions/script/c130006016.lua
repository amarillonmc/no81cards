--反转世界的白鸦 乌拉诺斯
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006016,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e3 = rsef.STF(c,EVENT_CONTROL_CHANGED,"dr",nil,"dr,tg,dh,dd",nil,nil,nil,nil,cm.op)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,1)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)	
end
function cm.tgfilter(c)
	return rsfz.IsSetM(c) and c:IsAbleToGrave()
end
function cm.op(e,tp,eg)
	local c = rscf.GetSelf(e)
	if not c then return end
	local p1,p2 = c:GetOwner(),c:GetControler()
	local sg = Duel.GetMatchingGroup(cm.tgfilter,p1,LOCATION_DECK,0,nil)
	if Duel.IsChainDisablable(0) and #sg > 0
		and rshint.SelectYesNo(p1,"tg") then
		rsgf.SelectToGrave(sg,p1,aux.TRUE,1,1,nil,{})
		Duel.NegateEffect(0)
		return
	end
	if Duel.Draw(p2,2,REASON_EFFECT) > 0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)==0
		and Duel.GetLocationCount(1 - c:GetControler(),LOCATION_MZONE)>0
end