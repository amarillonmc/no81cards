--反转世界的曦光 布丽姬
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006015,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e2 = rsef.FTF(c,EVENT_MOVE,"ctrl",nil,"ctrl,sp",nil,LOCATION_MZONE,cm.con,nil,cm.tg,cm.op)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	
end
function cm.con(e,tp,eg)
	local c = e:GetHandler()
	return eg:FilterCount(cm.cfilter,c,c,tp) == 1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return true end
	local tc = eg:Filter(cm.cfilter,c,c,tp):GetFirst()
	Duel.SetTargetCard(tc)
end
function cm.cfilter(c,rc,tp)
	return rc:GetColumnGroup():IsContains(c) and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.spfilter2(c,e,tp,code)
	return rscf.spfilter2()(c,e,tp) and c:IsCode(code)
end
function cm.op(e,tp,eg)
	local c,tc = rscf.GetSelf(e), rscf.GetTargetCard()
	if not c or not tc then return end
	local p1,p2 = c:GetOwner(),c:GetControler()
	local sg = Duel.GetMatchingGroup(cm.spfilter2,p1,rsloc.de,0,nil,e,tp,tc:GetCode())
	if Duel.IsChainDisablable(0) and #sg > 0
		and rshint.SelectYesNo(p1,"sp") then
		rsgf.SelectSpecialSummon(sg,p1,aux.TRUE,1,1,nil,{0,p1,p1,false,false,POS_FACEUP},e,tp)
		Duel.NegateEffect(0)
		return
	end
	Duel.SwapControl(c,tc)
end
function cm.spfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end