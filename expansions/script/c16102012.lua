--SCP-2000 机械降神
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102012,"SCP")
c16102012.dfc_front_side=16102011
c16102012.dfc_back_side=16102012
function cm.initial_effect(c)
	local e0=rsef.ACT(c)
	local e1=rsef.SV_IMMUNE_EFFECT(c,rsval.imes)
	--local e2=rsef.FV_LIMIT_PLAYER(c,"res",nil,cm.restg,{1,1})
	local e3=rsef.FV_LIMIT_PLAYER(c,"dr",nil,nil,{1,0})
	local e4=rsef.I(c,{m,0},{1},"sp",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DRAW_COUNT)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	--changge
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.backon)
	e6:SetOperation(cm.backop)
	c:RegisterEffect(e6)
end
function cm.restg(e,c)
	return c==e:GetHandler()
end
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("SCP") and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsType(TYPE_MONSTER)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP,nil,{"leave",LOCATION_DECK }},e,tp)
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,1,m-1)
end